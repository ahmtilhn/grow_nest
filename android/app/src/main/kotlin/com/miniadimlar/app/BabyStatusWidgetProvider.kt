package com.miniadimlar.app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.util.concurrent.TimeUnit
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class BabyStatusWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.baby_status_widget)
            bindWidget(context, views, widgetData)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun bindWidget(
        context: Context,
        views: RemoteViews,
        widgetData: SharedPreferences,
    ) {
        val openApp = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)

        val hasSession = widgetData.getBoolean("hasSession", false)
        if (!hasSession) {
            views.setViewVisibility(R.id.widget_content, View.GONE)
            views.setViewVisibility(R.id.widget_empty, View.VISIBLE)
            views.setOnClickPendingIntent(R.id.widget_empty, openApp)
            views.setTextViewText(
                R.id.widget_empty,
                widgetData.getString("emptyMessage", null) ?: "Uygulamayı açın",
            )
            return
        }

        views.setViewVisibility(R.id.widget_content, View.VISIBLE)
        views.setViewVisibility(R.id.widget_empty, View.GONE)
        views.setOnClickPendingIntent(R.id.widget_header, openApp)
        views.setTextViewText(
            R.id.widget_baby_name,
            "BAKIM KUMANDASI",
        )
        views.setTextViewText(
            R.id.widget_day_label,
            "Bugün",
        )
        val feedingAt = widgetData.getLongOrNull("feedingAt")
        views.setTextViewText(
            R.id.widget_feeding_time,
            timeWithAgo(feedingAt),
        )
        views.setTextViewText(
            R.id.widget_feeding_value,
            widgetData.getString("feedingDetail", null).orEmpty(),
        )
        val feedOptions = listOf(
            widgetData.getIntOption("feedOption1", 60),
            widgetData.getIntOption("feedOption2", 90),
            widgetData.getIntOption("feedOption3", 120),
        )
        bindFeedingAction(context, views, R.id.widget_feed_60, feedOptions[0], widgetData.getBoolean("canAddFeeding", false))
        bindFeedingAction(context, views, R.id.widget_feed_90, feedOptions[1], widgetData.getBoolean("canAddFeeding", false))
        bindFeedingAction(context, views, R.id.widget_feed_120, feedOptions[2], widgetData.getBoolean("canAddFeeding", false))
        bindOpenApp(context, views, R.id.widget_feed_other)

        val diaperAt = widgetData.getLongOrNull("diaperAt")
        views.setTextViewText(
            R.id.widget_diaper_time,
            timeWithAgo(diaperAt),
        )
        views.setTextViewText(
            R.id.widget_diaper_value,
            widgetData.getString("diaperDetail", null).orEmpty(),
        )
        bindAction(context, views, R.id.widget_diaper_wet, "grownestwidget://diaper?type=wet", widgetData.getBoolean("canAddDiaper", false))
        bindAction(context, views, R.id.widget_diaper_dirty, "grownestwidget://diaper?type=dirty", widgetData.getBoolean("canAddDiaper", false))
        bindAction(context, views, R.id.widget_diaper_both, "grownestwidget://diaper?type=both", widgetData.getBoolean("canAddDiaper", false))

        val isSleeping = widgetData.getBoolean("isSleeping", false)
        val sleepStatus = widgetData.getString("sleepDetail", null)
            ?.takeIf { it.isNotBlank() }
            ?: if (isSleeping) "Uyuyor" else ""
        val sleepMinutes = widgetData.getInt("sleepMinutes", 0).coerceAtLeast(0)
        val sleepGoalMinutes = widgetData.getInt("sleepGoalMinutes", 14 * 60).coerceAtLeast(1)
        val sleepProgress = ((sleepMinutes * 100) / sleepGoalMinutes).coerceIn(0, 100)
        views.setTextViewText(
            R.id.widget_sleep_label,
            sleepStatus.ifBlank { "Toplam Uyku" },
        )
        views.setTextViewText(
            R.id.widget_sleep_total,
            "${shortDuration(sleepMinutes)} / ${shortDuration(sleepGoalMinutes)}",
        )
        views.setTextViewText(
            R.id.widget_sleep_action,
            if (isSleeping) "Uyandı" else "Uyku Başladı",
        )
        views.setProgressBar(R.id.widget_sleep_progress, 100, sleepProgress, false)

        bindAction(
            context,
            views,
            R.id.widget_sleep_area,
            "grownestwidget://sleep",
            widgetData.getBoolean("canManageSleep", false),
        )
        bindAction(
            context,
            views,
            R.id.widget_sleep_action,
            "grownestwidget://sleep",
            widgetData.getBoolean("canManageSleep", false),
        )
    }

    private fun bindAction(
        context: Context,
        views: RemoteViews,
        viewId: Int,
        uri: String,
        enabled: Boolean,
    ) {
        views.setBoolean(viewId, "setEnabled", enabled)
        views.setFloat(viewId, "setAlpha", if (enabled) 1.0f else 0.45f)
        val intent = if (enabled) {
            HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse(uri))
        } else {
            HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
        }
        views.setOnClickPendingIntent(viewId, intent)
    }

    private fun bindFeedingAction(
        context: Context,
        views: RemoteViews,
        viewId: Int,
        amount: Int,
        enabled: Boolean,
    ) {
        views.setTextViewText(viewId, amount.toString())
        bindAction(context, views, viewId, "grownestwidget://feeding?ml=$amount", enabled)
    }

    private fun bindOpenApp(
        context: Context,
        views: RemoteViews,
        viewId: Int,
    ) {
        views.setBoolean(viewId, "setEnabled", true)
        views.setFloat(viewId, "setAlpha", 1.0f)
        views.setOnClickPendingIntent(
            viewId,
            HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
        )
    }

    private fun SharedPreferences.getLongOrNull(key: String): Long? {
        val raw = all[key] ?: return null
        val value = when (raw) {
            is Long -> raw
            is Int -> raw.toLong()
            is String -> raw.toLongOrNull() ?: 0L
            else -> 0L
        }
        return value.takeIf { it > 0L }
    }

    private fun SharedPreferences.getIntOption(key: String, fallback: Int): Int {
        val raw = all[key] ?: return fallback
        return when (raw) {
            is Int -> raw
            is Long -> raw.toInt()
            is String -> raw.toIntOrNull() ?: fallback
            else -> fallback
        }.coerceIn(10, 300)
    }

    private fun timeAgo(timestampMillis: Long?): String {
        if (timestampMillis == null) return "--"
        val elapsedMillis = (System.currentTimeMillis() - timestampMillis).coerceAtLeast(0L)
        val minutes = TimeUnit.MILLISECONDS.toMinutes(elapsedMillis).coerceAtMost(9999L)
        if (minutes < 60) return "${minutes}dk önce"
        val hours = minutes / 60
        val minutePart = (minutes % 60).toString().padStart(2, '0')
        return "${hours}s ${minutePart}dk önce"
    }

    private fun timeWithAgo(timestampMillis: Long?): String {
        if (timestampMillis == null) return "--"
        val clock = SimpleDateFormat("HH:mm", Locale("tr", "TR")).format(Date(timestampMillis))
        return "$clock  (${timeAgo(timestampMillis)})"
    }

    private fun shortDuration(minutes: Int): String {
        if (minutes < 60) return "${minutes}dk"
        return "${minutes / 60}s"
    }
}
