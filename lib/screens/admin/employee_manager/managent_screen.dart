import 'package:app_food_2023/screens/admin/admin_screen.dart';

import 'package:app_food_2023/widgets/custom_widgets/appbar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/admincontrollers/edit_specific_employee.dart';
import '../../../widgets/custom_widgets/transitions_animations.dart';
import 'add_employees.dart';

import 'change_role.dart';
import 'edit_specific_employees.dart';

class ManagementEmployees extends StatefulWidget {
  @override
  _ManagementEmployeesState createState() => _ManagementEmployeesState();
}

class _ManagementEmployeesState extends State<ManagementEmployees> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onPressed: () {
          slideinTransition(context, AdminScreen());
        },
        title: 'Danh sách nhân viên',
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('Role', isNotEqualTo: 'Customer')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: Image.network(
                    doc['Avatar'],
                  ).image,
                ),
                title: Text(doc['Role']),
                subtitle: Text(
                  doc['Email'],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Get.put(EditSpecificEmployeeController(doc.id));

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditSpecificEmployees(doc: doc),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.perm_identity),
                      onPressed: () {
                        Get.put(EditSpecificEmployeeController(doc.id));

                        slideinTransition(
                          context,
                          ChangeRoleEmployees(
                            doc: doc,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          slideinTransition(context, AddEmployees());
        },
      ),
    );
  }
}
