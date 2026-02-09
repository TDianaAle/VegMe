import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._init();
  NotificationService._init();
  
  static NotificationService get instance => _instance;
  
  final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  bool _initialized = false;
  
  Future<void> initialize() async {
    if (_initialized) return;
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(settings);
    _initialized = true;
  }
  
  Future<void> showShoppingListReady(int itemCount) async {
    await initialize();
    
    const androidDetails = AndroidNotificationDetails(
      'shopping_list_channel',
      'Lista Spesa',
      channelDescription: 'Notifiche per la lista della spesa',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      0,
      '🛒 Lista Spesa Pronta!',
      'Hai $itemCount ingredienti da comprare questa settimana',
      details,
    );
  }
  
  Future<void> showReminderNotification() async {
    await initialize();
    
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Promemoria',
      channelDescription: 'Promemoria per fare la spesa',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(
      1,
      '🔔 Promemoria Spesa',
      'Non dimenticare di fare la spesa per questa settimana!',
      details,
    );
  }
}