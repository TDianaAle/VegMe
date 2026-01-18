import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum CursorType {
  tomato,    
  carrot,    
  salad,    
  avocado,   
  broccoli,  
}

class CustomCursorService {
  static final CustomCursorService instance = CustomCursorService._init();
  CustomCursorService._init();

  final ValueNotifier<CursorType> currentCursor = ValueNotifier(CursorType.tomato);
  final ValueNotifier<Offset> cursorPosition = ValueNotifier(Offset.zero);
  final ValueNotifier<bool> isHovering = ValueNotifier(false);

  void setCursor(CursorType type) {
    currentCursor.value = type;
  }

  void updatePosition(Offset position) {
    cursorPosition.value = position;
  }

  void setHovering(bool hovering) {
    isHovering.value = hovering;
  }

  String getCursorEmoji(CursorType type) {
    switch (type) {
      case CursorType.tomato:
        return '🍅';
      case CursorType.carrot:
        return '🥕';
      case CursorType.salad:
        return '🥗';
      case CursorType.avocado:
        return '🥑';
      case CursorType.broccoli:
        return '🥦';
    }
  }
}

/// Widget with custom  cursor overlay
class CustomCursorOverlay extends StatelessWidget {
  final Widget child;
  final CursorType cursorType;

  const CustomCursorOverlay({
    super.key,
    required this.child,
    this.cursorType = CursorType.tomato,
  });

  @override
  Widget build(BuildContext context) {
    // not on mobile
    if (!kIsWeb) return child;

    return Stack(
      children: [
        // main content with MouseRegion to track position
        MouseRegion(
          cursor: SystemMouseCursors.none, 
          onHover: (event) {
            CustomCursorService.instance.updatePosition(event.position);
            CustomCursorService.instance.setHovering(true);
          },
          onExit: (event) {
            CustomCursorService.instance.setHovering(false);
          },
          child: child,
        ),
        
        // Custom cursor
        ValueListenableBuilder<bool>(
          valueListenable: CustomCursorService.instance.isHovering,
          builder: (context, isHovering, _) {
            if (!isHovering) return SizedBox.shrink();
            
            return ValueListenableBuilder<Offset>(
              valueListenable: CustomCursorService.instance.cursorPosition,
              builder: (context, position, _) {
                return Positioned(
                  left: position.dx - 12,
                  top: position.dy - 12,
                  child: IgnorePointer(
                    child: Text(
                      CustomCursorService.instance.getCursorEmoji(cursorType),
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

/// Widget wrapper for hoverable areas with custom cursor
class CustomCursorArea extends StatefulWidget {
  final Widget child;
  final CursorType cursorType;
  final VoidCallback? onTap;

  const CustomCursorArea({
    super.key,
    required this.child,
    this.cursorType = CursorType.tomato,
    this.onTap,
  });

  @override
  State<CustomCursorArea> createState() => _CustomCursorAreaState();
}

class _CustomCursorAreaState extends State<CustomCursorArea> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      // on mobile no hover effect
      return GestureDetector(
        onTap: widget.onTap,
        child: widget.child,
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          transform: _isHovering 
              ? (Matrix4.identity()..scale(1.02))
              : Matrix4.identity(),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Mixin for specific screens to set custom cursor type
mixin CustomCursorMixin<T extends StatefulWidget> on State<T> {
  CursorType get screenCursorType;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      CustomCursorService.instance.setCursor(screenCursorType);
    }
  }
}