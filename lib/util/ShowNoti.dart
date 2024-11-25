import 'package:flutter/material.dart';

void showTopMessage(
    BuildContext context, String message, Color boxColor, Color textColor) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10, // Below status bar
      left: 10,
      right: 10,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: textColor),
                onPressed: () => overlayEntry.remove(),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Insert the overlay entry
  overlay.insert(overlayEntry);

  // Auto-dismiss after 3 seconds
  Future.delayed(Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}
