import 'package:flutter/material.dart';
import 'package:gtaos/widgets/loading_overlay.dart';

import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/dynamicSeletor.dart';
import 'package:gtaos/views/add_product.dart';
import 'package:gtaos/views/attendance.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    asynce();
  }

  List<DynamicSelector>? pList;
  asynce([force = false]) async {
    pList = await networkCaller.getDynamicFormData(force);
    if (mounted) setState(() {});
  }

  getBody() {
    if (pList == null)
      return Center(
          child: CircularProgressIndicator(backgroundColor: Colors.orange));
    else {
      if (pList!.isEmpty)
        return Center(child: Text("No data available"));
      else
        return ListView.builder(
          itemBuilder: (c, i) => ProductWidget(
              isEnabled: true,
              model: pList![i].model!,
              price: pList![i].price!,
              productName: pList![i].name!,
              quantity: pList![i].price!,
              onedit: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) =>
                            AddProductScreen(dynamicSelector: pList![i])));
                asynce(true);
              },
              onDelete: () async {
                showDialog(
                    context: context,
                    builder: (c) => SimpleDialog(
                          title: Text("Are you sure?"),
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text("This cannot be undone.")),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("cancel")),
                                SizedBox(width: 10),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      LoadingOverlay.show(context);
                                      var res = await networkCaller
                                          .deleteProduct(pList![i].productId);
                                      if (res != null && res) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Deleted Successfully")),
                                        );
                                        pList?.remove(pList![i]);
                                        setState(() {});
                                      }
                                    },
                                    child: Text("ok")),
                              ],
                            )
                          ],
                        ));
              }),
          itemCount: pList!.length,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
                context, MaterialPageRoute(builder: (c) => AddProductScreen()));
            asynce(true);
          },
          label: Text("Add product"),
        ),
        appBar: AppBar(
          title: const Text('Products'),
        ),
        body: getBody());
  }
}

class ProductWidget extends StatelessWidget {
  final String productName;
  final String model;
  final String price;
  final String quantity;
  final bool isEnabled;
  final onDelete, onedit;

  ProductWidget({
    required this.productName,
    required this.model,
    required this.price,
    required this.quantity,
    required this.isEnabled,
    required this.onDelete,
    this.onedit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                SizedBox(width: 20),
                // Switch(
                //   value: isEnabled,
                //   onChanged: (bool value) {},
                // ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              model,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 20),
                // Text(
                //   'Qty: $quantity',
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Colors.grey[600],
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    if (onedit != null) {
                      onedit?.call();
                    }
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.grey[600],
                    size: 28,
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    if (onDelete != null) {
                      onDelete?.call();
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 28,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
