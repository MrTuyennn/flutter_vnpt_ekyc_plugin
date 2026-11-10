package com.jk.ekyc

import android.app.Activity
import android.content.Intent
import com.vnptit.idg.sdk.utils.KeyResultConstants as R
import com.vnptit.idg.sdk.utils.SDKEnum

internal object EkycResultMapper {

    fun toMap(resultCode: Int, data: Intent?): Map<String, Any?> {
        if (resultCode != Activity.RESULT_OK || data == null) {
            return mapOf("status" to "cancelled")
        }
        val lastStep = data.getStringExtra(R.LAST_STEP)
        val finished = lastStep == null || lastStep == SDKEnum.LastStepEnum.Done.getValue()
        if (!finished) {
            return mapOf("status" to "cancelled", "lastStep" to lastStep)
        }

        fun s(key: String): String? = data.getStringExtra(key)

        // COMPARE_QR_CODE_OCR_RESULT không có trạng thái "chưa chạy" ở một số flow (luôn là
        // false khi QR không chạy); QR_CODE_RESULT mới là tín hiệu đáng tin cậy, nên dựa vào đó.
        val qrCodeResult = s(R.QR_CODE_RESULT)

        return mapOf(
            "status" to "completed",
            "lastStep" to lastStep,
            "ocrResult" to s(R.OCR_RESULT),
            "compareFaceResult" to s(R.COMPARE_FACE_RESULT),
            "livenessFaceResult" to s(R.LIVENESS_FACE_RESULT),
            "maskedFaceResult" to s(R.MASKED_FACE_RESULT),
            "livenessCardFrontResult" to s(R.LIVENESS_CARD_FRONT_RESULT),
            "livenessCardBackResult" to s(R.LIVENESS_CARD_BACK_RESULT),
            "qrCodeResult" to qrCodeResult,
            "qrCodeResultDetail" to s(R.DETAIL_QR_CODE_RESULT),
            "retryQrCodeResult" to s(R.RETRY_QRCODE_RESULT),
            "compareQrCodeOcr" to
                if (qrCodeResult.isNullOrEmpty()) {
                    null
                } else {
                    data.getBooleanExtra(R.COMPARE_QR_CODE_OCR_RESULT, false)
                },
            "clientSession" to s(R.CLIENT_SESSION_RESULT),
            "transactionId" to s(R.TRANSACTION_ID_RESULT),
            "transactionPartnerId" to s(R.TRANSACTION_PARTNER_ID_RESULT),
            "networkProblem" to s(R.NETWORK_PROBLEM),
            "errorClient" to data.getStringArrayListExtra(R.ERROR_CLIENT),
            "pathImageFront" to s(R.PATH_IMAGE_FRONT_FULL),
            "pathImageFrontCropped" to s(R.PATH_IMAGE_FRONT_CROPPED),
            "pathImageBack" to s(R.PATH_IMAGE_BACK_FULL),
            "pathImageBackCropped" to s(R.PATH_IMAGE_BACK_CROPPED),
            "pathImageFace" to s(R.PATH_IMAGE_FACE_FULL),
            "pathImageFaceNear" to s(R.PATH_IMAGE_FACE_NEAR_FULL),
            "pathImageFaceFar" to s(R.PATH_IMAGE_FACE_FAR_FULL),
            "pathImageQrCode" to s(R.PATH_IMAGE_QRCODE_FULL),
            "pathImageQrCodeCropped" to s(R.PATH_IMAGE_QRCODE_CROPPED),
            "hashImageFront" to s(R.HASH_IMAGE_FRONT),
            "hashImageBack" to s(R.HASH_IMAGE_BACK),
            "hashImageFace" to s(R.HASH_IMAGE_FACE),
            "hashImageFaceNear" to s(R.HASH_IMAGE_FACE_NEAR),
            "hashImageFaceFar" to s(R.HASH_IMAGE_FACE_FAR),
            "hashImageQrCode" to s(R.HASH_IMAGE_QRCODE),
            "hashFaceScan3d" to s(R.HASH_FACE_SCAN3D),
        )
    }
}
