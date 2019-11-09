import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class HomePageChangeEvent {
  String url;
  HomePageChangeEvent(this.url);
}
