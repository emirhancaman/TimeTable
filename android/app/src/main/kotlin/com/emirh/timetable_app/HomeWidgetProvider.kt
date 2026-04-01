package com.emirh.timetable_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider as AppHomeWidgetProvider

class HomeWidgetProvider : AppHomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                // Open App on Widget Click
                /*
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)
                */

                val title = widgetData.getString("title", "No Title")
                val message = widgetData.getString("message", "No Message")

                setTextViewText(R.id.widget_title, title)
                setTextViewText(R.id.widget_message, message)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
