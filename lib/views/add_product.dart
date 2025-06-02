import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gtaos/widgets/loading_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/dynamicSeletor.dart';
import 'package:gtaos/model/product_add_model.dart';
import 'package:gtaos/model/product_for_update.dart';
import 'package:gtaos/utils/colors.dart';
import 'package:gtaos/widget/other_widgets.dart';

class AddProductScreen extends StatefulWidget {
  final DynamicSelector? dynamicSelector;
  const AddProductScreen({Key? key, this.dynamicSelector}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen>
    with SingleTickerProviderStateMixin {
  DateTime? dateTime = DateTime.now();
  bool isRequired = true, subtractStock = false;
  var nameController = TextEditingController();
  var optionValueCOntoller = TextEditingController();
  var modelCOntoller = TextEditingController();
  var quantityCOntoller = TextEditingController();
  var priceCOntoller = TextEditingController();
  var minQuantityCOntoller = TextEditingController();
  XFile? photo;
  List<XFile> photos = [];
  late ProductAddModel productAddModel;
  late ProductDescription productDescription;
  List<ProductOption> productOptionList = [];
  ProductOptionValue? productOptionValue;
  List<ProductOptionValueAddModel> productOptionValues = [];
  ProductOptionValueAddModel productOptionValueAddModel =
      ProductOptionValueAddModel();
  Option? selectorOption;
  var titleController = TextEditingController();

  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ProductForUpdate? productForUpdate;
  getProductForUpdate() async {
    LoadingOverlay.show(context);
    productForUpdate =
        await networkCaller.getProduct(widget.dynamicSelector!.productId);
    productDescription.name = productForUpdate!.data!.name;
    productDescription.metaTitle = productForUpdate!.data!.metaTitle;
    productAddModel.model = productForUpdate!.data!.model;
    productAddModel.quantity = productForUpdate!.data!.quantity;
    productAddModel.minimum = productForUpdate!.data!.minimum;
    productAddModel.price = productForUpdate!.data!.price;
    productAddModel.stockStatusId = productForUpdate!.data!.stockStatusId;
    productAddModel.shipping = productForUpdate!.data!.shipping;
    productAddModel.subtract = productForUpdate!.data!.subtract;
    productAddModel.image = productForUpdate!.data!.image;
    productAddModel.pid = productForUpdate!.data!.productId;
    handleRest();
    LoadingOverlay.dismiss();

    setState(() {});
  }

  bool get isUpdate => widget.dynamicSelector != null;
  @override
  void initState() {
    super.initState();
    log(widget.dynamicSelector?.toJson().toString() ?? "add mode");
    productDescription = ProductDescription(metaTitle: "", name: '');
    productAddModel =
        ProductAddModel(productDescription: [], productOption: []);
    if (widget.dynamicSelector != null) {
      _tabController = TabController(length: 2, vsync: this);

      getProductForUpdate();
    } else {
      _tabController = TabController(length: 4, vsync: this);

      handleRest();
    }
  }

  handleRest() {
    nameController.text = productDescription.name!;
    titleController.text = productDescription.metaTitle!;
    modelCOntoller.text = productAddModel.model ?? "";
    quantityCOntoller.text = productAddModel.quantity ?? "";
    minQuantityCOntoller.text = productAddModel.minimum ?? "";
    priceCOntoller.text = productAddModel.price ?? "";

    if (!networkCaller.isAdminMode)
      productAddModel.employeeId = networkCaller.getUser()?.employeeId;
    productAddModel.vendorId = networkCaller.getUser()?.vendorId;
  }

  images() {
    return ListView(
      children: <Widget>[
        SizedBox(height: 40),
        if (photo != null)
          kIsWeb
              ? Image.network(
                  (photo!.path),
                  height: 200,
                  width: 200,
                )
              : Image.file(
                  File(photo!.path),
                  height: 200,
                  width: 200,
                )
        else
          FractionallySizedBox(
              widthFactor: .5,
              child: ImagePlaceholder(
                  onPressed: () async {
                    photo = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        preferredCameraDevice:
                            kDebugMode ? CameraDevice.rear : CameraDevice.front,
                        requestFullMetadata: true,
                        imageQuality: 50);
                    setState(() {});
                  },
                  size: 200)),
        SizedBox(height: 20),
        Center(
            child: AppButton(
          text: photo != null ? "Change image" : "Take Selfie",
          shadowColor: Appcolors.primary1,
          width: 150,
          color: Appcolors.primary1,
          onTap: () {},
        )),
        if (photo != null) ...[
          SizedBox(height: 20),
          Center(
              child: AppButton(
            text: "Add photo",
            shadowColor: Appcolors.primary1,
            width: 150,
            color: Colors.green,
            onTap: () async {
              var pj = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  preferredCameraDevice:
                      kDebugMode ? CameraDevice.rear : CameraDevice.front,
                  requestFullMetadata: true,
                  imageQuality: 50);
              if (pj != null) photos.add(pj);
              setState(() {});
            },
          ))
        ],
        if (photos.isNotEmpty) ...[
          for (var img in photos)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                File(img.path),
                height: 200,
                width: 200,
              ),
            )
        ]
      ],
    );
  }

  getName(id) {
    return networkCaller.dynamicSelector!
        .map((e) => e.option)
        .expand((element) => element!)
        .toList()
        .firstWhere((e) => e.optionId == id)
        .name;
  }

  getNameOfOption(id) {
    return networkCaller.dynamicSelector!
        .map((e) => e.option)
        .expand((element) => element!)
        .where((element) => element.type == "select")
        .where((element) =>
            element.productOptionValue == selectorOption!.productOptionValue)
        .map((e) => e.productOptionValue)
        .expand((element) => element!)
        .toList()
        .firstWhere((e) => e.optionValueId == id)
        .name;
  }

  optionMaker() {
    return ListView(
      children: <Widget>[
        for (var option in productOptionList)
          Card(
            child: ListTile(
              title: Text(getName(option.optionId)),
              trailing: IconButton(
                  onPressed: () {
                    productOptionList.remove(option);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete)),
            ),
          ),
        if (networkCaller.dynamicSelector != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              isExpanded: true,
              value: selectorOption,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), label: Text("Option")),
              items: [
                ...networkCaller.dynamicSelector!
                    .map((e) => e.option)
                    .expand((element) => element!)
                    .toList()
                    .map<DropdownMenuItem<Option>>((e) => DropdownMenuItem(
                          child: Text(
                            e.name ?? "-",
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: e,
                        ))
                    .toList()
              ],
              onChanged: (value) {
                selectorOption = value;
                log(selectorOption!.type!);
                log(selectorOption!.required!);
                productOptionValueAddModel = ProductOptionValueAddModel();
                isRequired = selectorOption!.required == "1";
                setState(() {});
              },
            ),
          ),
        if (selectorOption != null) ...[
          CheckboxListTile(
              title: Text("Required"),
              value: isRequired,
              onChanged: (v) {
                isRequired = v!;
                setState(() {});
              }),
          if (selectorOption!.type == "text")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: optionValueCOntoller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Option Value")),
              ),
            ),
          if (selectorOption!.type == "date")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                readOnly: true,
                controller: optionValueCOntoller,
                onTap: () async {
                  var dt = await showDatePicker(
                      context: context,
                      initialDate: dateTime ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 1000)),
                      lastDate: DateTime.now().add(Duration(days: 1000)));
                  if (dt != null) {
                    dateTime = dt;
                    optionValueCOntoller.text =
                        DateFormat("yyyy-MM-dd HH:mm:ss").format(dt);
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Date of Task")),
              ),
            ),
          if (selectorOption!.type == "select")
            Card(
              child: Column(children: [
                for (var ov in productOptionValues)
                  ListTile(
                      title: Text(getNameOfOption(ov.optionValueId)),
                      trailing: IconButton(
                          onPressed: () {
                            productOptionValues.remove(ov);
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: productOptionValue,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), label: Text("Value")),
                    items: [
                      ...networkCaller.dynamicSelector!
                          .map((e) => e.option)
                          .expand((element) => element!)
                          .where((element) => element.type == "select")
                          .where((element) =>
                              element.productOptionValue ==
                              selectorOption!.productOptionValue)
                          .map((e) => e.productOptionValue)
                          .expand((element) => element!)
                          .toList()
                          .map<DropdownMenuItem<ProductOptionValue>>(
                              (e) => DropdownMenuItem(
                                    child: Text(
                                      e.name ?? "-",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    value: e,
                                  ))
                          .toList()
                    ],
                    onChanged: (value) {
                      productOptionValue = value;

                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: optionValueCOntoller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), label: Text("Quantity")),
                  ),
                ),
                CheckboxListTile(
                    title: Text("Subtract Stock"),
                    value: subtractStock,
                    onChanged: (v) {
                      subtractStock = v!;
                      setState(() {});
                    }),
                PriceInputWidget(
                  label: "Price",
                  onPricechanged: (v) {
                    productOptionValueAddModel.price = v;
                    setState(() {});
                  },
                  onRadioSelected: (v) {
                    productOptionValueAddModel.pricePrefix = v;
                    setState(() {});
                  },
                ),
                PriceInputWidget(
                  label: "Points",
                  onPricechanged: (v) {
                    productOptionValueAddModel.points = v;
                    setState(() {});
                  },
                  onRadioSelected: (v) {
                    productOptionValueAddModel.pointsPrefix = v;
                    setState(() {});
                  },
                ),
                PriceInputWidget(
                  label: "Weights",
                  onPricechanged: (v) {
                    productOptionValueAddModel.weight = v;
                    setState(() {});
                  },
                  onRadioSelected: (v) {
                    productOptionValueAddModel.weightPrefix = v;
                    setState(() {});
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                      onPressed: () {
                        productOptionValueAddModel.optionValueId =
                            productOptionValue!.optionValueId;
                        productOptionValueAddModel.quantity =
                            optionValueCOntoller.text.trim();
                        productOptionValueAddModel.subtract =
                            subtractStock ? "1" : "0";
                        productOptionValues.add(productOptionValueAddModel);
                        optionValueCOntoller.clear();
                        productOptionValue = null;
                        productOptionValueAddModel =
                            ProductOptionValueAddModel();
                        setState(() {});
                      },
                      child: Text("Add Value")),
                )
              ]),
            ),
          SizedBox(height: 10),
          FractionallySizedBox(
            widthFactor: .5,
            child: ElevatedButton(
                onPressed: () {
                  ProductOption productOption = ProductOption(
                    optionId: selectorOption!.optionId!,
                    required: isRequired ? "1" : "0",
                  );
                  if (selectorOption!.type != "select") {
                    productOption.value = optionValueCOntoller.text.trim();
                  } else {
                    productOption.productOptionValue = productOptionValues;
                  }
                  productOptionList.add(productOption);
                  optionValueCOntoller.clear();
                  selectorOption = null;
                  dateTime = DateTime.now();
                  setState(() {});
                },
                child: Text("Add")),
          )
        ]
      ],
    );
  }

  _general() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), label: Text("Name")),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: titleController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), label: Text("Title")),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                productAddModel.productDescription = [productDescription];
                productAddModel.productOption = productOptionList;
                productDescription.name = nameController.text.trim();
                productDescription.metaTitle = titleController.text.trim();
                productAddModel.productDescription = [productDescription];
                productAddModel.price = priceCOntoller.text.trim();
                productAddModel.quantity = quantityCOntoller.text.trim();
                productAddModel.minimum = minQuantityCOntoller.text.trim();
                productAddModel.model = modelCOntoller.text.trim();
                productAddModel.productImage = [
                  ProductImage(
                      image:
                          "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                      sortOrder: 0)
                ];
                productAddModel.image =
                    productAddModel.productImage!.first.image;
                LoadingOverlay.show(context);
                try {
                  if (isUpdate)
                    await networkCaller.editproduct(productAddModel);
                  else
                    await networkCaller.addproduct(productAddModel);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Product added successfully")),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("API error: " + e.toString())),
                  );
                }

                log(productAddModel.toJson().toString());
              },
              icon: const Icon(Icons.save))
        ],
        title: Text(isUpdate ? 'Update Product' : 'Add product'),
        bottom: TabBar(
          // isScrollable: true,
          controller: _tabController,
          tabs: [
            Tab(text: 'General'),
            Tab(text: 'Data'),
            if (!isUpdate) ...[Tab(text: 'Images'), Tab(text: 'Options')],
          ],
          onTap: (index) {
            _tabController.animateTo(index);
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // General tab
          _general(),
          // data tab
          data(),
          if (!isUpdate) ...[
            // Images tab
            images(),
            // Options tab
            optionMaker()
          ],
        ],
      ),
    );
  }

  data() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: modelCOntoller,
            decoration: InputDecoration(
                border: OutlineInputBorder(), label: Text("Model")),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: quantityCOntoller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(), label: Text("Quantity")),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: minQuantityCOntoller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(), label: Text("Minimum Quantity")),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: priceCOntoller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(), label: Text("Price ")),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Status",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Spacer(),
            Radio(
              value: "1",
              groupValue: productAddModel.stockStatusId,
              onChanged: (value) {
                setState(() {
                  productAddModel.stockStatusId = value!;
                });
              },
            ),
            Text(
              "Enabled",
              style: TextStyle(fontSize: 15),
            ),
            Radio(
              value: "0",
              groupValue: productAddModel.stockStatusId,
              onChanged: (value) {
                setState(() {
                  productAddModel.stockStatusId = value!;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Disabled",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        CheckboxListTile(
            title: Text("Requires shiping"),
            value: productAddModel.shipping == "1",
            onChanged: (v) {
              if (v!)
                productAddModel.shipping = "1";
              else
                productAddModel.shipping = "0";
              setState(() {});
            }),
        CheckboxListTile(
            title: Text("Subtact Stock"),
            value: productAddModel.subtract == "1",
            onChanged: (v) {
              if (v!)
                productAddModel.subtract = "1";
              else
                productAddModel.subtract = "0";
              setState(() {});
            }),
      ],
    );
  }
}

class PriceInputWidget extends StatefulWidget {
  const PriceInputWidget(
      {super.key,
      required this.label,
      required this.onRadioSelected,
      required this.onPricechanged});

  final String label;
  final onRadioSelected, onPricechanged;

  @override
  _PriceInputWidgetState createState() => _PriceInputWidgetState();
}

class _PriceInputWidgetState extends State<PriceInputWidget> {
  String _selectedOption = "+";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Radio(
                value: "+",
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                    widget.onRadioSelected(_selectedOption);
                  });
                },
              ),
              Text(
                "+",
                style: TextStyle(fontSize: 20),
              ),
              Radio(
                value: "-",
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value!;
                    widget.onRadioSelected(_selectedOption);
                  });
                },
              ),
              Text(
                "-",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                onChanged: (v) {
                  widget.onPricechanged(v.trim());
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: widget.label,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
