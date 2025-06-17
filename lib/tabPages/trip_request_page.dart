// import 'package:driver_app/tabPages/newmap.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:latlong2/latlong.dart';

// class TripRequestsPage extends StatelessWidget {
//   final DatabaseReference tripsRef = FirebaseDatabase.instance.ref().child(
//     "tripRequests",
//   );

//   void _updateTripStatus(
//     String tripId,
//     String newStatus,
//     BuildContext context,
//   ) {
//     tripsRef
//         .child(tripId)
//         .update({"status": newStatus})
//         .then((_) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("تم تحديث حالة الرحلة إلى $newStatus"),
//               backgroundColor: Colors.green,
//             ),
//           );
//         })
//         .catchError((error) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("فشل في تحديث الحالة: $error"),
//               backgroundColor: Colors.red,
//             ),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("طلبات الرحلات"),
//         backgroundColor: Colors.indigo,
//       ),
//       body: StreamBuilder<DatabaseEvent>(
//         stream: tripsRef.onValue,
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
//             Map<dynamic, dynamic> data =
//                 snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

//             // تصفية الطلبات التي حالتها "pending"
//             List<Map<String, dynamic>> pendingTrips = [];

//             data.forEach((key, value) {
//               Map<String, dynamic> trip = Map<String, dynamic>.from(value);
//               if (trip['status'] == 'pending') {
//                 trip['tripId'] = key;
//                 pendingTrips.add(trip);
//               }
//             });

//             if (pendingTrips.isEmpty) {
//               return Center(child: Text("لا توجد طلبات جديدة."));
//             }

//             return ListView.builder(
//               itemCount: pendingTrips.length,
//               itemBuilder: (context, index) {
//                 final trip = pendingTrips[index];
//                 final from = trip['from'];
//                 final to = trip['to'];
//                 final tripId = trip['tripId'];

//                 return Card(
//                   margin: EdgeInsets.all(8),
//                   child: ListTile(
//                     title: Text(
//                       "من: ${from['latitude']}, ${from['longitude']}",
//                     ),
//                     subtitle: Text(
//                       "إلى: ${to['latitude']}, ${to['longitude']}",
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.check, color: Colors.green),
//                           onPressed: () {
//                             _updateTripStatus(tripId, 'accepted', context);
//                           },
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.close, color: Colors.red),
//                           onPressed: () {
//                             _updateTripStatus(tripId, 'rejected', context);
//                           },
//                         ),
//                       ],
//                     ),
//                     // 🟢 أضف هذا الكود:
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (context) => TripRouteMapPage(
//                                 fromLocation: LatLng(
//                                   from['latitude'],
//                                   from['longitude'],
//                                 ),
//                                 toLocation: LatLng(
//                                   to['latitude'],
//                                   to['longitude'],
//                                 ),
//                               ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           } else if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else {
//             return Center(child: Text("لا توجد بيانات."));
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:driver_app/tabPages/newmap.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';

class TripRequestsPage extends StatefulWidget {
  @override
  _TripRequestsPageState createState() => _TripRequestsPageState();
}

class _TripRequestsPageState extends State<TripRequestsPage> {
  final DatabaseReference tripsRef = FirebaseDatabase.instance.ref().child(
    "tripRequests",
  );
  final DatabaseReference driversRef = FirebaseDatabase.instance.ref().child(
    "drivers",
  );

  String driverName = "";
  String driverPhone = "";

  @override
  void initState() {
    super.initState();
    _loadDriverInfo();
  }

  Future<void> _loadDriverInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final driverSnapshot = await driversRef.child(user.uid).get();
      if (driverSnapshot.exists) {
        final data = driverSnapshot.value as Map<dynamic, dynamic>;
        setState(() {
          driverName = data['name'] ?? "";
          driverPhone = data['phone'] ?? "";
        });
      }
    }
  }

  void _updateTripStatus(
    String tripId,
    String newStatus,
    BuildContext context,
  ) {
    tripsRef
        .child(tripId)
        .update({
          "status": newStatus,
          if (newStatus == 'accepted') ...{
            "driverName": driverName,
            "driverPhone": driverPhone,
          },
        })
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("تم تحديث حالة الرحلة إلى $newStatus"),
              backgroundColor: Colors.green,
            ),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("فشل في تحديث الحالة: $error"),
              backgroundColor: Colors.red,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "طلبات الرحلات",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.lightGreenAccent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: tripsRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> data =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

            List<Map<String, dynamic>> pendingTrips = [];

            data.forEach((key, value) {
              Map<String, dynamic> trip = Map<String, dynamic>.from(value);
              if (trip['status'] == 'pending') {
                trip['tripId'] = key;
                pendingTrips.add(trip);
              }
            });

            if (pendingTrips.isEmpty) {
              return const Center(
                child: Text(
                  "لا توجد طلبات جديدة.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: pendingTrips.length,
              itemBuilder: (context, index) {
                final trip = pendingTrips[index];
                final from = trip['from'];
                final to = trip['to'];
                final tripId = trip['tripId'];

                final distance = double.tryParse(trip['distance'].toString());
                final fare = double.tryParse(trip['fare'].toString());

                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    title: Text(
                      "من: ${from['latitude']}, ${from['longitude']}\n"
                      "إلى: ${to['latitude']}, ${to['longitude']}",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "المسافة: ${distance != null ? distance.toStringAsFixed(2) : 'غير متوفرة'} كم\n"
                        "السعر: ${fare != null ? fare.toStringAsFixed(2) : 'غير متوفر'} \$",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.greenAccent,
                          ),
                          onPressed: () {
                            _updateTripStatus(tripId, 'accepted', context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            _updateTripStatus(tripId, 'rejected', context);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TripRouteMapPage(
                                fromLocation: LatLng(
                                  from['latitude'],
                                  from['longitude'],
                                ),
                                toLocation: LatLng(
                                  to['latitude'],
                                  to['longitude'],
                                ),
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.lightGreenAccent),
            );
          } else {
            return const Center(
              child: Text(
                "لا توجد بيانات.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("طلبات الرحلات"),
  //       backgroundColor: Colors.lightGreenAccent[400],
  //     ),
  //     body: StreamBuilder<DatabaseEvent>(
  //       stream: tripsRef.onValue,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
  //           Map<dynamic, dynamic> data =
  //               snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

  //           List<Map<String, dynamic>> pendingTrips = [];

  //           data.forEach((key, value) {
  //             Map<String, dynamic> trip = Map<String, dynamic>.from(value);
  //             if (trip['status'] == 'pending') {
  //               trip['tripId'] = key;
  //               pendingTrips.add(trip);
  //             }
  //           });

  //           if (pendingTrips.isEmpty) {
  //             return Center(child: Text("لا توجد طلبات جديدة."));
  //           }

  //           return ListView.builder(
  //             itemCount: pendingTrips.length,
  //             itemBuilder: (context, index) {
  //               final trip = pendingTrips[index];
  //               final from = trip['from'];
  //               final to = trip['to'];
  //               final tripId = trip['tripId'];

  //               // قراءة المسافة والسعر
  //               final distance = double.tryParse(trip['distance'].toString());
  //               final fare = double.tryParse(trip['fare'].toString());

  //               return Card(
  //                 margin: EdgeInsets.all(8),
  //                 child: ListTile(
  //                   title: Text(
  //                     "من: ${from['latitude']}, ${from['longitude']}\n"
  //                     "إلى: ${to['latitude']}, ${to['longitude']}",
  //                   ),
  //                   subtitle: Text(
  //                     "المسافة: ${distance != null ? distance.toStringAsFixed(2) : 'غير متوفرة'} كم\n"
  //                     "السعر: ${fare != null ? fare.toStringAsFixed(2) : 'غير متوفر'} \$",
  //                   ),

  //                   trailing: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       IconButton(
  //                         icon: Icon(Icons.check, color: Colors.green),
  //                         onPressed: () {
  //                           _updateTripStatus(tripId, 'accepted', context);
  //                         },
  //                       ),
  //                       IconButton(
  //                         icon: Icon(Icons.close, color: Colors.red),
  //                         onPressed: () {
  //                           _updateTripStatus(tripId, 'rejected', context);
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                   onTap: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder:
  //                             (context) => TripRouteMapPage(
  //                               fromLocation: LatLng(
  //                                 from['latitude'],
  //                                 from['longitude'],
  //                               ),
  //                               toLocation: LatLng(
  //                                 to['latitude'],
  //                                 to['longitude'],
  //                               ),
  //                             ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               );
  //             },
  //           );
  //         } else if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         } else {
  //           return Center(child: Text("لا توجد بيانات."));
  //         }
  //       },
  //     ),
  //   );
  // }
}
