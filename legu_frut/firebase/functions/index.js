const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const { google } = require("googleapis");

// ─── Google Sheets Config ─────────────────────────────────────────────────────
const SPREADSHEET_ID = "1nAlWv0-phS-H1QMH04XFZZpgAERC44Jiv94z0LijY";
// ─────────────────────────────────────────────────────────────────────────────

const kFcmTokensCollection = "fcm_tokens";
const kPushNotificationsCollection = "ff_push_notifications";
const kUserPushNotificationsCollection = "ff_user_push_notifications";
const firestore = admin.firestore();

const kPushNotificationRuntimeOpts = {
  timeoutSeconds: 540,
  memory: "2GB",
};

exports.addFcmToken = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    return "Failed: Unauthenticated calls are not allowed.";
  }
  const userDocPath = data.userDocPath;
  const fcmToken = data.fcmToken;
  const deviceType = data.deviceType;
  if (
    typeof userDocPath === "undefined" ||
    typeof fcmToken === "undefined" ||
    typeof deviceType === "undefined" ||
    userDocPath.split("/").length <= 1 ||
    fcmToken.length === 0 ||
    deviceType.length === 0
  ) {
    return "Invalid arguments encoutered when adding FCM token.";
  }
  if (context.auth.uid != userDocPath.split("/")[1]) {
    return "Failed: Authenticated user doesn't match user provided.";
  }
  const existingTokens = await firestore
    .collectionGroup(kFcmTokensCollection)
    .where("fcm_token", "==", fcmToken)
    .get();
  var userAlreadyHasToken = false;
  for (var doc of existingTokens.docs) {
    const user = doc.ref.parent.parent;
    if (user.path != userDocPath) {
      // Should never have the same FCM token associated with multiple users.
      await doc.ref.delete();
    } else {
      userAlreadyHasToken = true;
    }
  }
  if (userAlreadyHasToken) {
    return "FCM token already exists for this user. Ignoring...";
  }
  await getUserFcmTokensCollection(userDocPath).doc().set({
    fcm_token: fcmToken,
    device_type: deviceType,
    created_at: admin.firestore.FieldValue.serverTimestamp(),
  });
  return "Successfully added FCM token!";
});

exports.sendPushNotificationsTrigger = functions
  .runWith(kPushNotificationRuntimeOpts)
  .firestore.document(`${kPushNotificationsCollection}/{id}`)
  .onCreate(async (snapshot, _) => {
    try {
      // Ignore scheduled push notifications on create
      const scheduledTime = snapshot.data().scheduled_time || "";
      if (scheduledTime) {
        return;
      }

      await sendPushNotifications(snapshot);
    } catch (e) {
      console.log(`Error: ${e}`);
      await snapshot.ref.update({ status: "failed", error: `${e}` });
    }
  });

exports.sendUserPushNotificationsTrigger = functions
  .runWith(kPushNotificationRuntimeOpts)
  .firestore.document(`${kUserPushNotificationsCollection}/{id}`)
  .onCreate(async (snapshot, _) => {
    try {
      // Ignore scheduled push notifications on create
      const scheduledTime = snapshot.data().scheduled_time || "";
      if (scheduledTime) {
        return;
      }

      // Don't let user-triggered notifications to be sent to all users.
      const userRefsStr = snapshot.data().user_refs || "";
      if (userRefsStr) {
        await sendPushNotifications(snapshot);
      }
    } catch (e) {
      console.log(`Error: ${e}`);
      await snapshot.ref.update({ status: "failed", error: `${e}` });
    }
  });

async function sendPushNotifications(snapshot) {
  const notificationData = snapshot.data();
  const title = notificationData.notification_title || "";
  const body = notificationData.notification_text || "";
  const imageUrl = notificationData.notification_image_url || "";
  const sound = notificationData.notification_sound || "";
  const parameterData = notificationData.parameter_data || "";
  const targetAudience = notificationData.target_audience || "";
  const initialPageName = notificationData.initial_page_name || "";
  const userRefsStr = notificationData.user_refs || "";
  const batchIndex = notificationData.batch_index || 0;
  const numBatches = notificationData.num_batches || 0;
  const status = notificationData.status || "";

  if (status !== "" && status !== "started") {
    console.log(`Already processed ${snapshot.ref.path}. Skipping...`);
    return;
  }

  if (title === "" || body === "") {
    await snapshot.ref.update({ status: "failed" });
    return;
  }

  const userRefs = userRefsStr === "" ? [] : userRefsStr.trim().split(",");
  var tokens = new Set();
  if (userRefsStr) {
    for (var userRef of userRefs) {
      const userTokens = await firestore
        .doc(userRef)
        .collection(kFcmTokensCollection)
        .get();
      userTokens.docs.forEach((token) => {
        if (typeof token.data().fcm_token !== undefined) {
          tokens.add(token.data().fcm_token);
        }
      });
    }
  } else {
    var userTokensQuery = firestore.collectionGroup(kFcmTokensCollection);
    // Handle batched push notifications by splitting tokens up by document
    // id.
    if (numBatches > 0) {
      userTokensQuery = userTokensQuery
        .orderBy(admin.firestore.FieldPath.documentId())
        .startAt(getDocIdBound(batchIndex, numBatches))
        .endBefore(getDocIdBound(batchIndex + 1, numBatches));
    }
    const userTokens = await userTokensQuery.get();
    userTokens.docs.forEach((token) => {
      const data = token.data();
      const audienceMatches =
        targetAudience === "All" || data.device_type === targetAudience;
      if (audienceMatches && typeof data.fcm_token !== undefined) {
        tokens.add(data.fcm_token);
      }
    });
  }

  const tokensArr = Array.from(tokens);
  var messageBatches = [];
  for (let i = 0; i < tokensArr.length; i += 500) {
    const tokensBatch = tokensArr.slice(i, Math.min(i + 500, tokensArr.length));
    const messages = {
      notification: {
        title,
        body,
        ...(imageUrl && { imageUrl: imageUrl }),
      },
      data: {
        initialPageName,
        parameterData,
      },
      android: {
        notification: {
          ...(sound && { sound: sound }),
        },
      },
      apns: {
        payload: {
          aps: {
            ...(sound && { sound: sound }),
          },
        },
      },
      tokens: tokensBatch,
    };
    messageBatches.push(messages);
  }

  var numSent = 0;
  await Promise.all(
    messageBatches.map(async (messages) => {
      const response = await admin.messaging().sendEachForMulticast(messages);
      numSent += response.successCount;
    }),
  );

  await snapshot.ref.update({ status: "succeeded", num_sent: numSent });
}

function getUserFcmTokensCollection(userDocPath) {
  return firestore.doc(userDocPath).collection(kFcmTokensCollection);
}

function getDocIdBound(index, numBatches) {
  if (index <= 0) {
    return "users/(";
  }
  if (index >= numBatches) {
    return "users/}";
  }
  const numUidChars = 62;
  const twoCharOptions = Math.pow(numUidChars, 2);

  var twoCharIdx = (index * twoCharOptions) / numBatches;
  var firstCharIdx = Math.floor(twoCharIdx / numUidChars);
  var secondCharIdx = Math.floor(twoCharIdx % numUidChars);
  const firstChar = getCharForIndex(firstCharIdx);
  const secondChar = getCharForIndex(secondCharIdx);
  return "users/" + firstChar + secondChar;
}

function getCharForIndex(charIdx) {
  if (charIdx < 10) {
    return String.fromCharCode(charIdx + "0".charCodeAt(0));
  } else if (charIdx < 36) {
    return String.fromCharCode("A".charCodeAt(0) + charIdx - 10);
  } else {
    return String.fromCharCode("a".charCodeAt(0) + charIdx - 36);
  }
}
exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  let firestore = admin.firestore();
  let userRef = firestore.doc("users/" + user.uid);
});

// =============================================================================
// EXPORTAR PEDIDOS DIARIOS A GOOGLE SHEETS
// Lee TODOS los productos de TODAS las órdenes del día (sin importar categoría)
// y los agrupa por productName sumando gramos y piezas.
// Crea/actualiza una pestaña por fecha en el Google Sheet.
// =============================================================================

/**
 * Trigger automático: corre todos los días a las 11:55 PM hora de México.
 * Si un día no hubo pedidos no escribe nada.
 */
exports.exportDailyOrdersToSheets = functions
  .runWith({ timeoutSeconds: 300, memory: "512MB" })
  .pubsub.schedule("55 23 * * *")
  .timeZone("America/Mexico_City")
  .onRun(async () => {
    const now = new Date();
    await exportOrdersForDate(now);
  });

/**
 * Trigger manual por HTTP: puedes llamarlo desde el navegador o con curl.
 * GET https://<region>-legufru-71350.cloudfunctions.net/exportOrdersManual
 * Parámetro opcional: ?date=2026-03-03  (si no se pone usa el día de hoy)
 * Parámetro opcional: ?status=entregado (filtra por status de orden)
 */
exports.exportOrdersManual = functions
  .runWith({ timeoutSeconds: 300, memory: "512MB" })
  .https.onRequest(async (req, res) => {
    try {
      const dateParam = req.query.date;
      const date = dateParam
        ? new Date(dateParam + "T12:00:00")
        : new Date();
      const count = await exportOrdersForDate(date);
      res.json({
        success: true,
        date: date.toISOString().split("T")[0],
        productsExported: count,
      });
    } catch (err) {
      console.error("Error exportando órdenes:", err);
      res.status(500).json({ success: false, error: err.message });
    }
  });

/**
 * Función core: lee todas las órdenes del día, agrupa todos los items
 * por productName (sumando gramos y piezas), y escribe en Google Sheets.
 *
 * @param {Date} date - Fecha a exportar
 * @returns {number} - Cantidad de productos únicos exportados
 */
async function exportOrdersForDate(date) {
  const db = admin.firestore();

  // Rango del día completo en hora de México (UTC-6)
  const mexicoCityOffset = -6 * 60; // minutos
  const utcDate = new Date(date.getTime() + (date.getTimezoneOffset() + mexicoCityOffset) * 60000);

  const startOfDay = new Date(utcDate);
  startOfDay.setHours(0, 0, 0, 0);
  const endOfDay = new Date(utcDate);
  endOfDay.setHours(23, 59, 59, 999);

  const dateStr = [
    startOfDay.getFullYear(),
    String(startOfDay.getMonth() + 1).padStart(2, "0"),
    String(startOfDay.getDate()).padStart(2, "0"),
  ].join("-");

  console.log(`[Sheets] Exportando órdenes para: ${dateStr}`);

  // ── 1. Obtener todas las órdenes del día ────────────────────────────────────
  const ordersSnap = await db
    .collection("orders")
    .where("createdAt", ">=", admin.firestore.Timestamp.fromDate(startOfDay))
    .where("createdAt", "<=", admin.firestore.Timestamp.fromDate(endOfDay))
    .get();

  if (ordersSnap.empty) {
    console.log(`[Sheets] No hay órdenes para ${dateStr}`);
    return 0;
  }

  console.log(`[Sheets] Órdenes encontradas: ${ordersSnap.size}`);

  // ── 2. Leer todos los items de todas las órdenes ────────────────────────────
  // Construye un mapa: productName → { totalGrams, totalPieces, unitType }
  const productMap = {};

  for (const orderDoc of ordersSnap.docs) {
    const itemsSnap = await orderDoc.ref.collection("ordersitems").get();

    for (const itemDoc of itemsSnap.docs) {
      const item = itemDoc.data();

      const productName = (item.productName || "Desconocido").trim();
      const unitType    = (item.unitType    || "Gramos").trim();
      const grams       = typeof item.grams      === "number" ? item.grams      : 0;
      const qtyPieces   = typeof item.qtyPieces  === "number" ? item.qtyPieces  : 0;

      if (!productMap[productName]) {
        productMap[productName] = {
          totalGrams:  0,
          totalPieces: 0,
          unitType:    unitType,
        };
      }

      productMap[productName].totalGrams  += grams;
      productMap[productName].totalPieces += qtyPieces;
      // Si alguna orden tiene unitType distinto, mantén el más informativo
      if (unitType !== "Gramos" && productMap[productName].unitType === "Gramos") {
        productMap[productName].unitType = unitType;
      }
    }
  }

  const productCount = Object.keys(productMap).length;
  console.log(`[Sheets] Productos únicos: ${productCount}`);

  if (productCount === 0) {
    console.log("[Sheets] No hay items en las órdenes. Nada que exportar.");
    return 0;
  }

  // ── 3. Construir filas para el Sheet ────────────────────────────────────────
  const rows = [["date", "productName", "totalGrams", "totalPieces", "unitType"]];
  const sortedNames = Object.keys(productMap).sort();

  for (const name of sortedNames) {
    const d = productMap[name];
    rows.push([dateStr, name, d.totalGrams, d.totalPieces, d.unitType]);
  }

  // ── 4. Autenticar con la cuenta de servicio de Firebase ────────────────────
  const auth = new google.auth.GoogleAuth({
    scopes: ["https://www.googleapis.com/auth/spreadsheets"],
  });
  const authClient = await auth.getClient();
  const sheets = google.sheets({ version: "v4", auth: authClient });

  // ── 5. Verificar si ya existe una pestaña para esta fecha ──────────────────
  const spreadsheet = await sheets.spreadsheets.get({
    spreadsheetId: SPREADSHEET_ID,
  });
  const existingTitles = spreadsheet.data.sheets.map(
    (s) => s.properties.title
  );

  if (!existingTitles.includes(dateStr)) {
    // Crear la pestaña nueva
    await sheets.spreadsheets.batchUpdate({
      spreadsheetId: SPREADSHEET_ID,
      requestBody: {
        requests: [
          {
            addSheet: {
              properties: { title: dateStr },
            },
          },
        ],
      },
    });
    console.log(`[Sheets] Pestaña creada: ${dateStr}`);
  } else {
    // Limpiar datos anteriores antes de reescribir
    await sheets.spreadsheets.values.clear({
      spreadsheetId: SPREADSHEET_ID,
      range: `${dateStr}!A:Z`,
    });
    console.log(`[Sheets] Pestaña existente limpiada: ${dateStr}`);
  }

  // ── 6. Escribir los datos ────────────────────────────────────────────────────
  await sheets.spreadsheets.values.update({
    spreadsheetId: SPREADSHEET_ID,
    range: `${dateStr}!A1`,
    valueInputOption: "RAW",
    requestBody: { values: rows },
  });

  console.log(
    `[Sheets] ✅ ${productCount} productos exportados a la pestaña ${dateStr}`
  );
  return productCount;
}
