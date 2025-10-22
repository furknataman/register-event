import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';

class EventDetailPage extends ConsumerWidget {
  final String eventId;

  const EventDetailPage({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement actual event data fetching
    // For now, using mock data
    final event = _getMockEvent(eventId);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.primaryBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('Detay'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header image with overlay
              Stack(
                children: [
                  Container(
                    height: 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      image: event['imageUrl'] != null
                          ? DecorationImage(
                              image: NetworkImage(event['imageUrl'] as String),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: event['imageUrl'] == null
                        ? Icon(Icons.event, size: 96, color: Colors.white.withValues(alpha: 0.6))
                        : null,
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.2),
                            Colors.black.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      event['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Info row in glass chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.schedule, size: 18, color: Colors.white),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  event['time'] as String,
                                  style: const TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 18, color: Colors.white),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  event['location'] as String,
                                  style: const TextStyle(color: Colors.white, fontSize: 15),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Registration status glass card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            (event['isRegistered'] as bool) ? Icons.check_circle : Icons.info,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              (event['isRegistered'] as bool)
                                  ? 'You are registered for this event'
                                  : 'Registration available',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    const Text('Description',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      event['description'] as String,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), height: 1.5),
                    ),
                    const SizedBox(height: 16),

                    if (event['speaker'] != null) ...[
                      const Text('Speaker',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              (event['speaker'] as String).substring(0, 1).toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(event['speaker'] as String,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: event['speakerTitle'] != null
                              ? Text(event['speakerTitle'] as String,
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8)))
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    const SizedBox(height: 16),

                    // Actions
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: (event['isRegistered'] as bool)
                            ? () => _showUnregisterDialog(context)
                            : () => _registerForEvent(context, eventId),
                        icon: Icon(
                          (event['isRegistered'] as bool) ? Icons.cancel : Icons.add,
                          color: Colors.white,
                        ),
                        label: Text(
                          (event['isRegistered'] as bool) ? 'Unregister' : 'Register',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (event['isRegistered'] as bool)
                              ? Colors.red
                              : Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getMockEvent(String eventId) {
    // Mock event data - replace with actual data fetching
    return {
      'id': eventId,
      'title': 'Modern Teaching Techniques Workshop',
      'description': 'Learn about the latest teaching methodologies and techniques that can help improve student engagement and learning outcomes. This workshop covers interactive teaching methods, technology integration, and assessment strategies.',
      'time': 'December 15, 2024 • 10:00 AM - 12:00 PM',
      'location': 'Conference Hall A',
      'speaker': 'Dr. Sarah Johnson',
      'speakerTitle': 'Educational Psychology Professor',
      'participantCount': 45,
      'duration': '2h',
      'isRegistered': false,
      'imageUrl': null,
    };
  }

  void _registerForEvent(BuildContext context, String eventId) {
    // TODO: Implement registration logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showUnregisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unregister from Event'),
        content: const Text('Are you sure you want to unregister from this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement unregistration logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Unregistered successfully'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Unregister', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

}

