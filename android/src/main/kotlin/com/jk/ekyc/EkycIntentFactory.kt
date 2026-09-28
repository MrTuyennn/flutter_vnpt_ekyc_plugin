package com.jk.ekyc

import android.content.Context
import android.content.Intent
import com.vnptit.idg.sdk.utils.KeyIntentConstants as K
import com.vnptit.idg.sdk.utils.SDKEnum

internal object EkycIntentFactory {

    fun build(context: Context, flow: String?, config: Map<String, Any?>?): Intent {
        requireNotNull(config) { "config is required" }
        val intent = Intent(context, VnptEkycPlugin.activityFor(flow))

        intent.putExtra(K.ACCESS_TOKEN, config.string("accessToken"))
        intent.putExtra(K.TOKEN_ID, config.string("tokenId"))
        intent.putExtra(K.TOKEN_KEY, config.string("tokenKey"))

        config.enum("documentType", DOCUMENT_TYPE)?.let { intent.putExtra(K.DOCUMENT_TYPE, it.getValue()) }
        config.enum("faceMode", FACE_MODE)?.let { intent.putExtra(K.VERSION_SDK, it.getValue()) }
        config.enum("language", LANGUAGE)?.let { intent.putExtra(K.LANGUAGE_SDK, it.getValue()) }
        config.enum("businessFlow", BUSINESS_FLOW)?.let { intent.putExtra(K.FLOW_EKYC, it.getValue()) }
        config.enum("validateDocument", VALIDATE_DOCUMENT)?.let { intent.putExtra(K.VALIDATE_DOCUMENT_TYPE, it.getValue()) }
        config.enum("livenessMode", LIVENESS)?.let { intent.putExtra(K.CHECK_LIVENESS_FACE, it.getValue()) }
        config.enum("faceOvalMode", FACE_OVAL)?.let { intent.putExtra(K.MODE_VERSION_FACE_OVAL, it.getValue()) }
        config.enum("cameraPositionForPortrait", CAMERA)?.let { intent.putExtra(K.CAMERA_POSITION_FOR_PORTRAIT, it.getValue()) }

        config.optString("challengeCode")?.let { intent.putExtra(K.CHALLENGE_CODE, it) }
        config.optString("inputClientSession")?.let { intent.putExtra(K.INPUT_CLIENT_SESSION, it) }
        config.optString("transactionId")?.let { intent.putExtra(K.TRANSACTION_ID, it) }
        config.optString("transactionPartnerId")?.let { intent.putExtra(K.TRANSACTION_PARTNER_ID, it) }
        config.optString("hashImageCompare")?.let { intent.putExtra(K.HASH_IMAGE_COMPARE, it) }
        config.optString("thresLevel")?.let { intent.putExtra(K.THRES_LEVEL, it) }
        config.optString("hashFrontOcr")?.let { intent.putExtra(K.HASH_FRONT_OCR, it) }
        config.optString("changeBaseUrl")?.let { intent.putExtra(K.CHANGE_BASE_URL, it) }

        config.bool("showTutorial")?.let { intent.putExtra(K.IS_SHOW_TUTORIAL, it) }
        config.bool("enableGotIt")?.let { intent.putExtra(K.IS_ENABLE_GOT_IT, it) }
        config.bool("showRequiredPermissionDecree")?.let { intent.putExtra(K.IS_SHOW_REQUIRED_PERMISSION_DECREE, it) }
        config.bool("enableScanQrCode")?.let { intent.putExtra(K.IS_ENABLE_SCAN_QRCODE, it) }
        config.bool("validatePostcode")?.let { intent.putExtra(K.IS_VALIDATE_POSTCODE, it) }
        config.bool("checkLivenessCard")?.let { intent.putExtra(K.IS_CHECK_LIVENESS_CARD, it) }
        config.bool("skipPreview")?.let { intent.putExtra(K.IS_SKIP_PREVIEW, it) }
        config.bool("checkMaskedFace")?.let { intent.putExtra(K.IS_CHECK_MASKED_FACE, it) }
        config.bool("enableCompare")?.let { intent.putExtra(K.IS_ENABLE_COMPARE, it) }
        config.bool("enableCompareGeneral")?.let { intent.putExtra(K.IS_COMPARE_GENERAL, it) }
        config.bool("enableCheckVirtualCamera")?.let { intent.putExtra(K.IS_ENABLE_CHECK_VIRTUAL_CAMERA, it) }
        config.bool("enableCheckEmulator")?.let { intent.putExtra(K.IS_ENABLE_CHECK_EMULATOR, it) }
        config.bool("enableCheckRooted")?.let { intent.putExtra(K.IS_ENABLE_CHECK_ROOTED, it) }
        config.bool("offline")?.let { intent.putExtra(K.IS_TURN_OFF_CALL_SERVICE, it) }

        (config["zoomCamera"] as? Number)?.let { intent.putExtra(K.ZOOM_CAMERA, it.toFloat()) }
        (config["timeoutCallApiSeconds"] as? Number)?.let { intent.putExtra(K.TIMEOUT_CALL_API, it.toInt()) }

        (config["blockedDocuments"] as? List<*>)?.let { names ->
            val values = names.map { name ->
                BLOCKED[name] ?: throw IllegalArgumentException("Unknown blocked document: $name")
            }
            intent.putExtra(K.LIST_BLOCKED_DOCUMENT, values.map { it.getValue() }.toIntArray())
        }

        (config["headers"] as? Map<*, *>)?.let { raw ->
            val headers = HashMap<String, String>()
            raw.forEach { (k, v) -> if (k is String && v is String) headers[k] = v }
            intent.putExtra(K.HEADERS_REQUEST, headers)
        }

        return intent
    }

    // Empty strings are the native SDK's own default and are accepted, e.g. when
    // config.offline is true and no VNPT credentials are needed.
    private fun Map<String, Any?>.string(key: String): String =
        this[key] as? String ?: throw IllegalArgumentException("config.$key is required")

    private fun Map<String, Any?>.optString(key: String): String? = this[key] as? String

    private fun Map<String, Any?>.bool(key: String): Boolean? = this[key] as? Boolean

    private fun <T> Map<String, Any?>.enum(key: String, table: Map<String, T>): T? {
        val name = this[key] as? String ?: return null
        return table[name] ?: throw IllegalArgumentException("Unknown $key: $name")
    }

    private val DOCUMENT_TYPE = mapOf(
        "identityCard" to SDKEnum.DocumentTypeEnum.IDENTITY_CARD,
        "identityCardChip" to SDKEnum.DocumentTypeEnum.IDENTITY_CARD_CHIP,
        "passport" to SDKEnum.DocumentTypeEnum.PASSPORT,
        "driverLicense" to SDKEnum.DocumentTypeEnum.DRIVER_LICENSE,
        "militaryCard" to SDKEnum.DocumentTypeEnum.MILITARY_CARD,
    )
    private val FACE_MODE = mapOf(
        "standard" to SDKEnum.VersionSDKEnum.STANDARD,
        "advanced" to SDKEnum.VersionSDKEnum.ADVANCED,
    )
    private val LANGUAGE = mapOf(
        "vietnamese" to SDKEnum.LanguageEnum.VIETNAMESE,
        "english" to SDKEnum.LanguageEnum.ENGLISH,
    )
    private val BUSINESS_FLOW = mapOf(
        "ntb" to SDKEnum.FlowEkycEnum.NTB,
        "etb" to SDKEnum.FlowEkycEnum.ETB,
        "verify" to SDKEnum.FlowEkycEnum.VERIFY,
    )
    private val VALIDATE_DOCUMENT = mapOf(
        "none" to SDKEnum.ValidateDocumentType.None,
        "basic" to SDKEnum.ValidateDocumentType.Basic,
        "medium" to SDKEnum.ValidateDocumentType.Medium,
        "advance" to SDKEnum.ValidateDocumentType.Advance,
    )
    private val LIVENESS = mapOf(
        "none" to SDKEnum.ModeCheckLiveNessFace.NONE,
        "iBeta" to SDKEnum.ModeCheckLiveNessFace.iBETA,
        "standard" to SDKEnum.ModeCheckLiveNessFace.STANDARD,
    )
    private val FACE_OVAL = mapOf(
        "farAndNear" to SDKEnum.ModeVersionFaceOval.FACE_FULL,
        "farOnly" to SDKEnum.ModeVersionFaceOval.FACE_FAR,
        "nearOnly" to SDKEnum.ModeVersionFaceOval.FACE_NEAR,
    )
    private val CAMERA = mapOf(
        "front" to SDKEnum.CameraTypeEnum.FRONT,
        "back" to SDKEnum.CameraTypeEnum.BACK,
    )
    private val BLOCKED = mapOf(
        "identityCard9" to SDKEnum.DocumentTypeBlockedEnum.IDENTITY_CARD_9,
        "identityCard12" to SDKEnum.DocumentTypeBlockedEnum.IDENTITY_CARD_12,
        "citizenIdCard" to SDKEnum.DocumentTypeBlockedEnum.CITIZEN_ID_CARD,
        "passport" to SDKEnum.DocumentTypeBlockedEnum.PASSPORT,
        "militaryCard" to SDKEnum.DocumentTypeBlockedEnum.MILITARY_CARD,
        "driverLicense" to SDKEnum.DocumentTypeBlockedEnum.DRIVER_LICENSE,
        "citizenIdChip" to SDKEnum.DocumentTypeBlockedEnum.CITIZEN_ID_CHIP,
        "citizenIdChip01072024" to SDKEnum.DocumentTypeBlockedEnum.CITIZEN_ID_CHIP_01072024,
    )
}
