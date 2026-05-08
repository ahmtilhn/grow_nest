package com.miniadimlar.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.app.FlutterApplication

class GrowNestApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        createDefaultNotificationChannel()
    }

    private fun createDefaultNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = getSystemService(NotificationManager::class.java)
        val channel = NotificationChannel(
            "mini_adimlar_soft_chime",
            "Aile bildirimleri",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = "Aile davetleri, kayıt güncellemeleri ve hatırlatıcılar"
            enableVibration(true)
        }
        manager.createNotificationChannel(channel)
    }
}
