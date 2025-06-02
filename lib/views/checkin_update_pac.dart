import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gtaos/widgets/loading_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/add.dart';
import 'package:gtaos/model/dynamicSeletor.dart';
import 'package:gtaos/model/paclist.dart';
import 'package:gtaos/model/updatepac.dart';
import 'package:gtaos/utils/colors.dart';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gtaos/widgets/loading_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/model/add.dart';
import 'package:gtaos/model/dynamicSeletor.dart';
import 'package:gtaos/model/paclist.dart';
import 'package:gtaos/model/updatepac.dart';
import 'package:gtaos/utils/colors.dart';

// Assuming you have a Customer model like this:
class Customer {
  final String id;
  final String name;

  Customer({required this.id, required this.name});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'].toString(),
      name: json['name'] as String,
    );
  }
}

// --- New SearchableDropdown Widget ---
class SearchableDropdown<T> extends StatefulWidget {
  final String labelText;
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemToString;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const SearchableDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    required this.itemToString,
    this.selectedItem,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  List<T> _filteredItems = [];
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    if (widget.selectedItem != null) {
      _searchController.text = widget.itemToString(widget.selectedItem!);
    }
  }

  @override
  void didUpdateWidget(covariant SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items ||
        oldWidget.selectedItem != widget.selectedItem) {
      _filteredItems = widget.items;
      if (widget.selectedItem != null &&
          _searchController.text != widget.itemToString(widget.selectedItem!)) {
        _searchController.text = widget.itemToString(widget.selectedItem!);
      } else if (widget.selectedItem == null && _searchController.text.isNotEmpty) {
        _searchController.clear();
      }
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchController.dispose();
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0), // Position below the text field
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4, // Max height for dropdown
              ),
              child: _filteredItems.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("No results found."),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return ListTile(
                          title: Text(widget.itemToString(item)),
                          onTap: () {
                            _searchController.text = widget.itemToString(item);
                            widget.onChanged(item);
                            _removeOverlay();
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => widget
              .itemToString(item)
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
    if (_overlayEntry == null && query.isNotEmpty) {
      _showOverlay();
    } else if (query.isEmpty) {
      _removeOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.0),
          hintStyle: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Appcolors.primary2),
          ),
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.grey.shade700),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon ??
              IconButton(
                icon: Icon(Icons.arrow_drop_down),
                onPressed: () {
                  if (_overlayEntry == null) {
                    _searchController.clear();
                    _filteredItems = widget.items;
                    _showOverlay();
                  } else {
                    _removeOverlay();
                  }
                },
              ),
        ),
        onTap: () {
          if (_overlayEntry == null) {
            _searchController.clear(); // Clear on tap to show all options
            _filteredItems = widget.items;
            _showOverlay();
          }
        },
        onChanged: _onSearchChanged,
        readOnly: false, // Make it editable for search
      ),
    );
  }
}

class CheckinUpadatePacScreen extends StatefulWidget {
  const CheckinUpadatePacScreen({super.key, required this.data});

  final Datum data;

  @override
  State<CheckinUpadatePacScreen> createState() =>
      _CheckinUpadatePacScreenState();
}

class _CheckinUpadatePacScreenState extends State<CheckinUpadatePacScreen> {
  Addpac? addpac;
  final TextEditingController _dateCon = TextEditingController();
  final TextEditingController _shippingCostCon = TextEditingController();
  final TextEditingController _messageCon = TextEditingController();
  DynamicSelector? _selectedDynamicSelector;
  bool? _hasCheckedIn;
  final Map<FieldOption, String> _optionValues = {};
  dynamic _attachedPhoto;
  ProductList? _currentProductListItem;
  late UpdatePacModel _updatePacModel;
List<Customer> _customerList = [];
  bool _createQuote = false;
  Customer? _selectedCustomer; // New: Selected customer

  @override
  void initState() {
    super.initState();
    _initializeData();
    _fetchCustomerList();
  }

  @override
  void dispose() {
    _dateCon.dispose();
    _shippingCostCon.dispose();
    _messageCon.dispose();
    super.dispose();
  }

Future<void> _fetchCustomerList() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Dummy customer data
    _customerList = [
      Customer(id: '1', name: 'Alpha Customer Services'),
      Customer(id: '2', name: 'Beta Solutions Inc.'),
      Customer(id: '3', name: 'Gamma Enterprises LLC'),
      Customer(id: '4', name: 'Delta Technologies Group'),
      Customer(id: '5', name: 'Epsilon Innovations'),
      Customer(id: '6', name: 'Zeta Corp'),
      Customer(id: '7', name: 'Eta Solutions'),
      Customer(id: '8', name: 'Theta Enterprises'),
      Customer(id: '9', name: 'Iota Inc.'),
      Customer(id: '10', name: 'Kappa Group'),
      Customer(id: '11', name: 'Lambda Solutions'),
      Customer(id: '12', name: 'Mu Enterprises'),
      Customer(id: '13', name: 'Nu Innovations'),
      Customer(id: '14', name: 'Xi Technologies'),
      Customer(id: '15', name: 'Omicron Services'),
    ];

    if (mounted) setState(() {});
    log("Dummy customer list loaded: ${_customerList.length} customers");
  }
  /// Initializes data for the screen, including PAC details and dynamic form data.
  Future<void> _initializeData() async {
    _updatePacModel = UpdatePacModel(
      productList: [],
      notes: "",
      attachname: "",
      attachpath: "",
    );
    _updatePacModel.taskId = widget.data.taskId;
    _updatePacModel.vendorId = networkCaller.getUser()?.vendorId;
    if (!networkCaller.isAdminMode) {
      _updatePacModel.employeeId = networkCaller.getUser()?.employeeId;
      _updatePacModel.firstName = networkCaller.getUser()?.name;
    }

    try {
      await _checkCheckinStatus();
      log("Widget data: ${widget.data.toJson()}");
      addpac = await networkCaller.getPac(widget.data.taskId);
      _updatePacModel.linkId = addpac!.link_id;
      _updatePacModel.taskStatusId = addpac!.task_status_id;
      _updatePacModel.taskstatus = addpac!.task_status;
      _updatePacModel.vtaskId = addpac!.v_task_id;

      await networkCaller.getDynamicFormData();
    } catch (e) {
      log("Error initializing data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() {});
    }
  }

  /// Sets up location and IP variables before uploading the PAC.
  Future<void> _setupVariablesBeforeUpload() async {
    var cp = await networkCaller.getUserCurrentLocation();
    _updatePacModel.lat = cp.latitude.toString();
    _updatePacModel.lan = cp.longitude.toString();
    _updatePacModel.ip = await networkCaller.getPublicIp();
  }

  /// Checks the current check-in status from the network caller.
  Future<void> _checkCheckinStatus() async {
    _hasCheckedIn = await networkCaller.checkInStatus();
    if (mounted) setState(() {});
  }

  /// Retrieves the product name based on its ID.
  String _getProductName(String? id) {
    if (id == null || networkCaller.dynamicSelector == null) return "-";
    return networkCaller.dynamicSelector!
            .firstWhere((element) => element.productId == id,
                orElse: () => DynamicSelector(name: "-"))
            .name ??
        "-";
  }

  /// Retrieves the product price based on its ID.
  String _getProductPrice(String? id) {
    if (id == null || networkCaller.dynamicSelector == null) return "0.00";
    return networkCaller.dynamicSelector!
            .firstWhere((element) => element.productId == id,
                orElse: () => DynamicSelector(price: "0.00"))
            .price ??
        "0.00";
  }

  /// Builds the section displaying all added products.
  Widget _buildProductListSection() {
    if (_updatePacModel.productList?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Added Products",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Appcolors.primary2,
                    fontSize: 18
                  ),
            ),
            const Divider(height: 24),
            for (var plist in _updatePacModel.productList!)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildProductListItem(plist),
              ),
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    "Grand Total",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Appcolors.primary2,
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                        ),
                  ),
                  const Spacer(),
                  Text(
                    _updatePacModel.totalPrice,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an individual product list item with quantity controls.
  Widget _buildProductListItem(ProductList plist) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        title: Text(
          _getProductName(plist.productId),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: _createQuote
            ? Text(
                "Rate ${_getProductPrice(plist.productId)} || ${plist.totalPrice}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_createQuote) ...[
              InkWell(
                onTap: () {
                  setState(() {
                    plist.quantity = (plist.quantity ?? 0) + 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.green),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "x${plist.quantity ?? 0}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Appcolors.primary2,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: plist.quantity == null || plist.quantity! <= 0
                    ? null
                    : () {
                        setState(() {
                          plist.quantity = (plist.quantity ?? 0) - 1;
                        });
                      },
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.remove, color: Colors.red),
                ),
              ),
            ],
            const SizedBox(width: 16),
            InkWell(
              onTap: () {
                setState(() {
                  _updatePacModel.productList?.remove(plist);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Provides a consistent input decoration style for text fields and dropdowns.
  InputDecoration _getInputDecoration(String labelText, {String? hintText}) {
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20,vertical: 12.0),
      hintStyle: TextStyle(
        fontFamily: 'Raleway',
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: Appcolors.primary2), // Highlight on focus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      errorStyle: const TextStyle(
        fontFamily: 'Raleway',
        fontSize: 11,
        color: Colors.red,
      ),
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey.shade700),
    );
  }

  /// Main body content of the screen, handling loading states and form fields.
  Widget _buildBodyContent() {
    if (networkCaller.dynamicSelector == null) {
      return Center(
        child: CircularProgressIndicator(color: Appcolors.primary2),
      );
    } else {
      if (networkCaller.dynamicSelector!.isEmpty) {
        return const Center(child: Text("No data available"));
      } else {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductListSection(),
              const SizedBox(height: 16),


             Container(
              // color: Colors.amber,
              child:
    DropdownButtonFormField<DynamicSelector>(
            //  alignment :Alignment.center,
                // padding: EdgeInsets.all(10),
                value: _selectedDynamicSelector,
                decoration: _getInputDecoration("Select Product/Service"),
                items: networkCaller.dynamicSelector!
                    .map<DropdownMenuItem<DynamicSelector>>(
                      
                      (e) => DropdownMenuItem(
                        value: e,
                        child: SizedBox(
                          width: 250,
                          child: Text(e.name ?? "-",
                          overflow: TextOverflow.ellipsis, // ... will appear for long text
             maxLines: 1,
                        
                        ) ,)
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDynamicSelector = value;
                    _currentProductListItem = ProductList(
                      productId: value!.productId!,
                      vendorId: _updatePacModel.vendorId,
                      employeeId: networkCaller.getUser()!.employeeId,
                      taskId: widget.data.taskId,
                      instyes: "1",
                      vTaskId: addpac!.v_task_id,
                      firstName: _updatePacModel.firstName,
                      paccsName: widget.data.subject,
                      message: "",
                      taskstatus: addpac!.task_status,
                      taskstatusId: addpac!.task_status_id,
                      option: [],
                    );
                    _optionValues.clear();
                    _dateCon.clear();
                  });
                },
              ),          ),
              if (_selectedDynamicSelector != null &&
                  _selectedDynamicSelector!.option != null) ...[
                const SizedBox(height: 24),
                Text(
                  "Product Options",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Appcolors.primary2,
                      ),
                ),
                const Divider(),
                // Now iterating over `Option` type
                for (var option in _selectedDynamicSelector!.option!)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,
                    vertical: 10),
                    child: _buildOptionField(option), // Pass `Option`
                  ),
              ],
              const SizedBox(height: 24),
              TextField(
                maxLines: 3,
                controller: _messageCon,
                onChanged: (val) {
                  _currentProductListItem?.message = val.trim();
                  _updatePacModel.notes = val.trim();
                },
                decoration: _getInputDecoration("Notes/Message",
                    hintText: "Enter any notes or message here"),
              ),
              const SizedBox(height: 16),
              // Text(
              //       "Customer Selection",
              //       style: Theme.of(context).textTheme.titleMedium?.copyWith(
              //             fontWeight: FontWeight.bold,
              //             color: Appcolors.primary2,
              //           ),
              //     ),
              //     const Divider(),
                  SearchableDropdown<Customer>(
                    labelText: "Search & Select Customer",
                    items: _customerList,
                    selectedItem: _selectedCustomer,
                    itemToString: (customer) => customer.name,
                    onChanged: (customer) {
                      setState(() {
                        _selectedCustomer = customer;
                        // You might want to update _updatePacModel.customerId here
                        // _updatePacModel.customerId = customer?.id;
                        log("Selected Customer: ${customer?.name} (ID: ${customer?.id})");
                      });
                    },
                    prefixIcon: const Icon(Icons.person_outline),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_selectedCustomer != null)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              setState(() {
                                _selectedCustomer = null;
                                // Clear the text field as well
                              });
                            },
                          ),
                        IconButton(
                          icon: const Icon(Icons.search, size: 20),
                          onPressed: () {
                            // Can add specific search logic here if needed,
                            // but the dropdown already handles filtering
                          },
                        ),
                      ],
                    ),
                  ),
                 
              const SizedBox(height: 16),

              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile(
                  title: const Text("Create Quote"),
                  value: _createQuote,
                  onChanged: (v) {
                    setState(() {
                      _createQuote = v;
                    });
                  },
                  activeColor: Appcolors.primary2,
                ),
              ),
              if (_createQuote)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextField(
                    controller: _shippingCostCon,
                    onChanged: (val) {
                      _updatePacModel.shippingCost = val.trim();
                      setState(() {});
                    },
                    keyboardType: TextInputType.number,
                    decoration: _getInputDecoration("Shipping Cost",
                        hintText: "Enter shipping cost"),
                  ),
                ),
              const SizedBox(height: 24),
         Column(children: [

          _buildAttachmentSection(),
            const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomLeft,
                child: ElevatedButton.icon(
                  onPressed: _selectedDynamicSelector == null
                      ? null
                      : () {
                          if (_currentProductListItem != null) {
                            _currentProductListItem!.option =
                                _optionValues.keys.toList();
                            _currentProductListItem!.price = _getProductPrice(
                                _currentProductListItem!.productId);
                            _updatePacModel.productList!
                                .add(_currentProductListItem!);
                            _selectedDynamicSelector = null;
                            _optionValues.clear();
                            _dateCon.clear();
                            _messageCon.clear();
                            _shippingCostCon.text =
                                _updatePacModel.shippingCost ?? "";
                            log("updatePacModel: ${_updatePacModel.toJson()}");
                            setState(() {});
                          }
                        },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text("Add to List"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Appcolors.primary2,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
               const SizedBox(height: 20),
               Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle "Add Customer" logic here
                        log("Add Customer button pressed");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Add Customer functionality goes here!')),
                        );
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text("Add Customer"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.primary2,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
         ],),     
             
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updatePacModel.productList!.isNotEmpty
                      ? _handleUpdatePac
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Appcolors.primary2,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text("Update Task"),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  /// Builds different input fields based on the option type (text, select, date).
  // Changed parameter type from DynamicSelectorOption to Option
  Widget _buildOptionField(Option option) {
    switch (option.type) {
      case "text":
        return TextField(
          onChanged: (val) {
            _optionValues[FieldOption(
                productOptionId: option.productOptionId,
                optionId: option.optionId,
                productOptionValueId: "",
                name: option.name,
                type: option.type,
                value: val.trim())] = val.trim();
            log("Option values: ${_optionValues.toString()}");
          },
          decoration: _getInputDecoration(option.name ?? "Text Input"),
        );
      case "select":
        return DropdownButtonFormField<ProductOptionValue>(
          key: ValueKey(option.name),
          decoration: _getInputDecoration(option.name ?? "Select Option"),
          value: _optionValues.keys
                  .firstWhere(
                      (element) =>
                          element.productOptionId == option.productOptionId,
                      orElse: () => FieldOption())
                  .value !=
              null
              ? option.productOptionValue?.firstWhere(
                  (element) =>
                      element.name ==
                      _optionValues.keys
                          .firstWhere(
                              (fOption) =>
                                  fOption.productOptionId ==
                                  option.productOptionId)
                          .value,
                  orElse: () => ProductOptionValue())
              : null,
          items: option.productOptionValue!
              .map<DropdownMenuItem<ProductOptionValue>>(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name ?? "-"),
                ),
              )
              .toList(),
          onChanged: (value) {
            log("Selected productOptionValueId: ${value?.productOptionValueId ?? "N/A"}");
            _optionValues[FieldOption(
                productOptionId: option.productOptionId,
                optionId: option.optionId,
                productOptionValueId: value?.productOptionValueId,
                name: option.name,
                type: option.type,
                value: value?.name)] = value?.name ?? "";
            setState(() {});
          },
        );
      case "date":
        return TextField(
          readOnly: true,
          controller: _dateCon,
          onTap: () async {
            var dt = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 1000)),
              lastDate: DateTime.now().add(const Duration(days: 1000)),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Appcolors.primary2,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Appcolors.primary2,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (dt != null) {
              _dateCon.text = DateFormat("yyyy-MM-dd HH:mm:ss").format(dt);
              _optionValues[FieldOption(
                  productOptionId: option.productOptionId,
                  optionId: option.optionId,
                  productOptionValueId: "",
                  name: option.name,
                  type: option.type,
                  value: _dateCon.text)] = _dateCon.text;
              setState(() {});
            }
          },
          decoration: _getInputDecoration(option.name ?? "Select Date"),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  /// Builds the section for attaching a photo.
  Widget _buildAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Attachment",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Appcolors.primary2,
              ),
        ),
        const Divider(),
        Row(
          children: [
            if (_attachedPhoto != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    _attachedPhoto!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _attachedPhoto != null
                    ? Colors.red.shade600
                    : Appcolors.primary2,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () async {
                if (_attachedPhoto != null) {
                  setState(() {
                    _attachedPhoto = null;
                  });
                } else {
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    requestFullMetadata: true,
                    imageQuality: 50,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _attachedPhoto = pickedFile;
                    });
                  }
                }
              },
              icon: Icon(
                _attachedPhoto != null ? Icons.delete_forever : Icons.attach_file,
              ),
              label: Text(_attachedPhoto != null ? "Remove" : "Attach File"),
            ),
          ],
        ),
      ],
    );
  }

  /// Handles the logic for updating the PAC (Product/Service/Activity Checklist).
  Future<void> _handleUpdatePac() async {
    // EasyLoading.show(status: 'Updating PAC...');
    try {
      if (_attachedPhoto != null) {
        var res = await networkCaller.uploadAttachment(_attachedPhoto!.path);
        _updatePacModel.attachname = _attachedPhoto!.name;
        _updatePacModel.attachpath = res["data"]["location1"];
      }
      await _setupVariablesBeforeUpload();
      log("updatePacModel after setupVariablesBeforeUpload: ${_updatePacModel.toJson()}");

      await networkCaller.updateThePac(_updatePacModel);
      // EasyLoading.dismiss();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      log("Error updating PAC: $e");
      // EasyLoading.dismiss();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update task: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Handles the check-in/checkout action.
  Future<void> _handleCheckinCheckout() async {
    // EasyLoading.show(status: _hasCheckedIn! ? 'Checking out...' : 'Checking in...');
    try {
      await networkCaller.checkin(_hasCheckedIn! ? 0 : 1,
          widget.data.taskId, addpac!.v_task_id);
      await _checkCheckinStatus();
      // EasyLoading.dismiss();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_hasCheckedIn!
                ? 'Checked out successfully!'
                : 'Checked in successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      log("Check-in/out error: $e");
      // EasyLoading.dismiss();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to check-in/out: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBodyContent(),
      floatingActionButton:
          !networkCaller.isAdminMode && _hasCheckedIn != null && addpac != null
              ? FloatingActionButton.extended(
                  backgroundColor:
                      _hasCheckedIn! ? Colors.red.shade700 : Colors.green.shade700,
                  foregroundColor: Colors.white,
                  onPressed: _handleCheckinCheckout,
                  label: Text(_hasCheckedIn! ? "Checkout" : "Checkin"),
                  icon: Icon(_hasCheckedIn! ? Icons.logout : Icons.login),
                )
              : null,
    );
  }
}



// class CheckinUpdatePacScreen extends StatefulWidget {
//   const CheckinUpdatePacScreen({super.key, required this.data});

//   final Datum data;

//   @override
//   State<CheckinUpdatePacScreen> createState() => _CheckinUpdatePacScreenState();
// }

// class _CheckinUpdatePacScreenState extends State<CheckinUpdatePacScreen> 
//     with TickerProviderStateMixin {
//   // Core data
//   Addpac? addpac;
//   DynamicSelector? dynamicSelector;
//   ProductList? productList;
//   late UpdatePacModel updatePacModel;
  
//   // State variables
//   bool? hasCheckedIn;
//   bool createQuote = false;
//   bool isLoading = true;
//   Map<FieldOption, String> fieldOptions = {};
//   var selectedPhoto;
  
//   // Controllers
//   final dateCon = TextEditingController();
//   final shippingCostCon = TextEditingController();
//   final messageCon = TextEditingController();
  
//   // Animation controllers
//   late AnimationController _slideController;
//   late AnimationController _fadeController;
  
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _initializeUpdateModel();
//     _loadInitialData();
//   }
  
//   void _initializeAnimations() {
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//   }
  
//   void _initializeUpdateModel() {
//     updatePacModel = UpdatePacModel(
//       productList: [],
//       notes: "",
//       attachname: "",
//       attachpath: "",
//     );
//     updatePacModel.taskId = widget.data.taskId;
//     updatePacModel.vendorId = networkCaller.getUser()?.vendorId;
    
//     if (!networkCaller.isAdminMode) {
//       updatePacModel.employeeId = networkCaller.getUser()?.employeeId;
//       updatePacModel.firstName = networkCaller.getUser()?.name;
//     }
//   }
  
//   Future<void> _loadInitialData() async {
//     try {
//       await Future.wait([
//         _checkCheckinStatus(),
//         _loadPacData(),
//       ]);
      
//       await networkCaller.getDynamicFormData();
//       _fadeController.forward();
//     } catch (e) {
//       log('Error loading initial data: $e');
//       _showErrorSnackBar('Failed to load data. Please try again.');
//     } finally {
//       if (mounted) {
//         setState(() => isLoading = false);
//       }
//     }
//   }
  
//   Future<void> _checkCheckinStatus() async {
//     hasCheckedIn = await networkCaller.checkInStatus();
//   }
  
//   Future<void> _loadPacData() async {
//     log(widget.data.toJson().toString());
//     addpac = await networkCaller.getPac(widget.data.taskId);
    
//     if (addpac != null) {
//       updatePacModel.linkId = addpac!.link_id;
//       updatePacModel.taskStatusId = addpac!.task_status_id;
//       updatePacModel.taskstatus = addpac!.task_status;
//       updatePacModel.vtaskId = addpac!.v_task_id;
//     }
//   }
  
//   Future<void> _setupLocationAndIP() async {
//     final location = await networkCaller.getUserCurrentLocation();
//     updatePacModel.lat = location.latitude.toString();
//     updatePacModel.lan = location.longitude.toString();
//     updatePacModel.ip = await networkCaller.getPublicIp();
//   }
  
//   String _getProductName(int id) {
//     try {
//       return networkCaller.dynamicSelector!
//           .firstWhere((element) => element.productId == id)
//           .name ?? '-';
//     } catch (e) {
//       return '-';
//     }
//   }
  
//   String _getProductPrice(int id) {
//     try {
//       return networkCaller.dynamicSelector!
//           .firstWhere((element) => element.productId == id)
//           .price ?? '0';
//     } catch (e) {
//       return '0';
//     }
//   }
  
//   void _showErrorSnackBar(String message) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }
  
//   void _showSuccessSnackBar(String message) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }
  
//   @override
//   void dispose() {
//     dateCon.dispose();
//     shippingCostCon.dispose();
//     messageCon.dispose();
//     _slideController.dispose();
//     _fadeController.dispose();
//     super.dispose();
//   }
  
//   Widget _buildLoadingScreen() {
//     return const Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 16),
//             Text('Loading task details...'),
//           ],
//         ),
//       ),
//     );
//   }
  
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.inbox_outlined,
//             size: 64,
//             color: Colors.grey.shade400,
//           ),
//           const Text(
//             'No products available',
//             style: TextStyle(fontSize: 18, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildProductList() {
//     if (updatePacModel.productList?.isEmpty ?? true) return const SizedBox();
    
//     return FadeTransition(
//       opacity: _fadeController,
//       child: Card(
//         elevation: 4,
//         margin: const EdgeInsets.all(16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Selected Products',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               ...updatePacModel.productList!.map(_buildProductItem),
//               const Divider(thickness: 2, height: 32),
//               _buildGrandTotal(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProductItem(ProductList product) {
//   return Container(
//     margin: const EdgeInsets.only(bottom: 8),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: Colors.grey.shade200),
//     ),
//     child: Stack(
//       children: [
//         ListTile(
//           contentPadding: const EdgeInsets.all(16),
//           title: Text( // No Expanded needed here directly within ListTile's title
//             _getProductName(product!.productId! as int),
//             style: const TextStyle(fontWeight: FontWeight.w500),
//             overflow: TextOverflow.ellipsis, // Add this
//             maxLines: 1, // Add this to limit lines
//           ),
//           subtitle: createQuote
//               ? Text(
//                   'Rate: ${_getProductPrice(product.productId as int)} | Total: ${product.totalPrice}',
//                   style: TextStyle(color: Colors.grey.shade600),
//                 )
//               : null,
//           trailing: _buildProductActions(product),
//         ),
//         if (createQuote)
//           Positioned(
//             top: 8,
//             right: 8,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Appcolors.primary2,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 'x${product.quantity ?? 0}',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     ),
//   );
// }
  
//   Widget _buildProductActions(ProductList product) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (createQuote) ...[
//           IconButton(
//             onPressed: () {
//               product.quantity = (product.quantity ?? 0) + 1;
//               setState(() {});
//             },
//             icon: const Icon(Icons.add_circle, color: Colors.green),
//           ),
//           IconButton(
//             onPressed: (product.quantity ?? 0) > 0
//                 ? () {
//                     product.quantity = (product.quantity ?? 1) - 1;
//                     setState(() {});
//                   }
//                 : null,
//             icon: const Icon(Icons.remove_circle, color: Colors.red),
//           ),
//         ],
//         IconButton(
//           onPressed: () {
//             updatePacModel.productList?.remove(product);
//             setState(() {});
//           },
//           icon: const Icon(Icons.delete_outline, color: Colors.red),
//         ),
//       ],
//     );
//   }
  
//   Widget _buildGrandTotal() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Grand Total',
//             style: TextStyle(
//               color: Appcolors.primary2,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             updatePacModel.totalPrice,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildFormField({
//     required String label,
//     Widget? child,
//     TextEditingController? controller,
//     String? hintText,
//     int maxLines = 1,
//     TextInputType? keyboardType,
//     void Function(String)? onChanged,
//     bool readOnly = false,
//     VoidCallback? onTap,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 8),
//           child ??
//               TextFormField(
//                 controller: controller,
//                 readOnly: readOnly,
//                 onTap: onTap,
//                 maxLines: maxLines,
//                 keyboardType: keyboardType,
//                 onChanged: onChanged,
//                 decoration: _getInputDecoration(hintText ?? label),
//               ),
//         ],
//       ),
//     );
//   }
  
//   InputDecoration _getInputDecoration(String hint) {
//     return InputDecoration(
//       isDense: true,
//       hintText: hint,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       hintStyle: TextStyle(
//         fontFamily: 'DM Sans',
//         fontSize: 14,
//         color: Colors.grey.shade600,
//       ),
//       filled: true,
//       fillColor: Colors.grey.shade50,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade200),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade200),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Appcolors.primary2, width: 2),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red),
//       ),
//     );
//   }
  
//   Widget _buildProductSelector() {
//     return _buildFormField(
//       label: 'Select Product',
//       child: DropdownButtonFormField<DynamicSelector>(
//         value: dynamicSelector,
//         decoration: _getInputDecoration('Choose a product'),
//         items: networkCaller.dynamicSelector!
//             .map((e) => DropdownMenuItem(
//                   value: e,
//                   child: Text(e.name ?? '-'),
//                 ))
//             .toList(),
//         onChanged: _onProductSelected,
//       ),
//     );
//   }
  
//   void _onProductSelected(DynamicSelector? value) {
//     if (value == null) return;
    
//     dynamicSelector = value;
//     productList = ProductList(
//       productId: value.productId!,
//       vendorId: updatePacModel.vendorId,
//       employeeId: networkCaller.getUser()!.employeeId,
//       taskId: widget.data.taskId,
//       instyes: "1",
//       vTaskId: addpac!.v_task_id,
//       firstName: updatePacModel.firstName,
//       paccsName: widget.data.subject,
//       message: "",
//       taskstatus: addpac!.task_status,
//       taskstatusId: addpac!.task_status_id,
//       option: [],
//     );
//     fieldOptions.clear();
//     setState(() {});
//   }
  
//   Widget _buildDynamicFields() {
//     if (dynamicSelector?.option == null) return const SizedBox();
    
//     return Column(
//       children: dynamicSelector!.option!.map(_buildDynamicField).toList(),
//     );
//   }
  
//   Widget _buildDynamicField(Option option) {
//     switch (option.type) {
//       case 'text':
//         return _buildFormField(
//           label: option.name ?? '-',
//           onChanged: (value) => _updateFieldOption(option, value),
//         );
      
//       case 'select':
//         if (option.productOptionValue == null) return const SizedBox();
//         return _buildFormField(
//           label: option.name ?? '-',
//           child: DropdownButtonFormField(
//             decoration: _getInputDecoration(option.name ?? '-'),
//             items: option.productOptionValue!
//                 .map((e) => DropdownMenuItem(
//                       value: e,
//                       child: Text(e.name ?? '-'),
//                     ))
//                 .toList(),
//             onChanged: (value) {
//               if (value != null) {
//                 _updateFieldOption(option, value.name!, value.productOptionValueId);
//               }
//             },
//           ),
//         );
      
//       case 'date':
//         return _buildFormField(
//           label: option.name ?? '-',
//           controller: dateCon,
//           readOnly: true,
//           onTap: () => _selectDate(option),
//         );
      
//       default:
//         return const SizedBox();
//     }
//   }
  
//   void _updateFieldOption(Option option, String value, [String? valueId]) {
//     final fieldOption = FieldOption(
//       productOptionId: option.productOptionId,
//       optionId: option.optionId,
//       productOptionValueId: valueId ?? "",
//       name: option.name,
//       type: option.type,
//       value: value.trim(),
//     );
//     fieldOptions[fieldOption] = value.trim();
//     setState(() {});
//   }
  
//   Future<void> _selectDate(Option option) async {
//     final selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now().subtract(const Duration(days: 1000)),
//       lastDate: DateTime.now().add(const Duration(days: 1000)),
//     );
    
//     if (selectedDate != null) {
//       final formattedDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(selectedDate);
//       dateCon.text = formattedDate;
//       _updateFieldOption(option, formattedDate);
//     }
//   }
  
//   Widget _buildPhotoSection() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Attachment',
//             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//           ),
//           const SizedBox(height: 12),
//           if (selectedPhoto != null) ...[
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.attachment, color: Colors.grey),
//                   const SizedBox(width: 8),
//                   Expanded(child: Text(selectedPhoto.name)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//           ],
//           ElevatedButton.icon(
//             onPressed: _handlePhotoAction,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: selectedPhoto != null ? Colors.red : Colors.green,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             icon: Icon(selectedPhoto != null ? Icons.delete : Icons.camera_alt),
//             label: Text(selectedPhoto != null ? 'Remove Photo' : 'Add Photo'),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Future<void> _handlePhotoAction() async {
//     if (selectedPhoto != null) {
//       selectedPhoto = null;
//     } else {
//       selectedPhoto = await ImagePicker().pickImage(
//         source: ImageSource.gallery,
//         requestFullMetadata: true,
//         imageQuality: 50,
//       );
//     }
//     setState(() {});
//   }
  
//   Widget _buildQuoteSection() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           SwitchListTile(
//             value: createQuote,
//             onChanged: (value) {
//               createQuote = value;
//               setState(() {});
//             },
//             title: const Text('Create Quote'),
//             tileColor: Colors.grey.shade50,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           if (createQuote) ...[
//             const SizedBox(height: 16),
//             _buildFormField(
//               label: 'Shipping Cost',
//               controller: shippingCostCon,
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 updatePacModel.shippingCost = value.trim();
//                 setState(() {});
//               },
//             ),
//           ],
//         ],
//       ),
//     );
//   }
  
//   Widget _buildActionButtons() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed: dynamicSelector != null ? _addProduct : null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Appcolors.primary2,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: const Icon(Icons.add),
//               label: const Text('Add Product', style: TextStyle(fontSize: 16)),
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: updatePacModel.productList!.isNotEmpty ? _updatePac : null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text('Update Task', style: TextStyle(fontSize: 16)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   void _addProduct() {
//     if (productList == null) return;
    
//     productList!.option = fieldOptions.keys.toList();
//     productList!.price = _getProductPrice(productList!.productId as int);
//     productList!.message = messageCon.text.trim();
    
//     updatePacModel.productList!.add(productList!);
    
//     // Reset form
//     dynamicSelector = null;
//     fieldOptions.clear();
//     dateCon.clear();
//     updatePacModel.shippingCost = shippingCostCon.text.trim();
    
//     _showSuccessSnackBar('Product added successfully');
//     setState(() {});
//   }
  
//   Future<void> _updatePac() async {
//     try {
//       LoadingOverlay.show(context);
      
//       if (selectedPhoto != null) {
//         final uploadResult = await networkCaller.uploadAttachment(selectedPhoto.path);
//         updatePacModel.attachname = selectedPhoto.name;
//         updatePacModel.attachpath = uploadResult["data"]["location1"];
//       }
      
//       await _setupLocationAndIP();
//       await networkCaller.updateThePac(updatePacModel);
      
//       _showSuccessSnackBar('Task updated successfully');
//       Navigator.pop(context);
//     } catch (e) {
//       _showErrorSnackBar('Failed to update task. Please try again.');
//       log('Update error: $e');
//     } finally {
//       LoadingOverlay.dismiss();
//     }
//   }
  
//   Future<void> _handleCheckinCheckout() async {
//     if (hasCheckedIn == null || addpac == null) return;
    
//     try {
//       LoadingOverlay.show(context);
//       await networkCaller.checkin(
//         hasCheckedIn! ? 0 : 1,
//         widget.data.taskId,
//         addpac!.v_task_id,
//       );
//       await _checkCheckinStatus();
//       setState(() {});
//     } catch (e) {
//       _showErrorSnackBar('Failed to update check-in status');
//     } finally {
//       LoadingOverlay.dismiss();
//     }
//   }
  
//   Widget _buildMainContent() {
//     if (networkCaller.dynamicSelector == null) {
//       return const Center(child: CircularProgressIndicator());
//     }
    
//     if (networkCaller.dynamicSelector!.isEmpty) {
//       return _buildEmptyState();
//     }
    
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildProductList(),
//           _buildProductSelector(),
//           _buildDynamicFields(),
//           _buildFormField(
//             label: 'Message',
//             controller: messageCon,
//             maxLines: 3,
//             hintText: 'Enter your message here...',
//             onChanged: (value) {
//               productList?.message = value.trim();
//             },
//           ),
//           _buildQuoteSection(),
//           _buildPhotoSection(),
//           _buildActionButtons(),
//           const SizedBox(height: 100), // Space for FAB
//         ],
//       ),
//     );
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) return _buildLoadingScreen();
    
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text('Update Task'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       floatingActionButton: !networkCaller.isAdminMode &&
//               hasCheckedIn != null &&
//               addpac != null
//           ? FloatingActionButton.extended(
//               backgroundColor: hasCheckedIn! ? Colors.red : Colors.green,
//               onPressed: _handleCheckinCheckout,
//               icon: Icon(hasCheckedIn! ? Icons.logout : Icons.login),
//               label: Text(hasCheckedIn! ? 'Check Out' : 'Check In'),
//             )
//           : null,
//       body: _buildMainContent(),
//     );
//   }
// }



// class CheckinUpadatePacScreen extends StatefulWidget {
//   const CheckinUpadatePacScreen({super.key, required this.data});

//   final Datum data;

//   @override
//   State<CheckinUpadatePacScreen> createState() =>
//       _CheckinUpadatePacScreenState();
// }

// class _CheckinUpadatePacScreenState extends State<CheckinUpadatePacScreen> {
//   Addpac? addpac;
//   var dateCon = TextEditingController();
//   var shipingCost = TextEditingController();
//   var mCon = TextEditingController();
//   DynamicSelector? dynamicSelector;
//   bool? hasCheckedIn;
//   Map<FieldOption, String> opyion = {};
//   var photo;
//   ProductList? productList;
//   late UpdatePacModel updatePacModel;

//   @override
//   void initState() {
//     super.initState();
//     getAsync();
//     updatePacModel = UpdatePacModel(
//         productList: [], notes: "", attachname: "", attachpath: "");
//     updatePacModel.taskId = widget.data.taskId;
//     updatePacModel.vendorId = networkCaller.getUser()?.vendorId;
//     if (!networkCaller.isAdminMode) {
//       updatePacModel.employeeId = networkCaller.getUser()?.employeeId;
//       updatePacModel.firstName = networkCaller.getUser()?.name;
//     }
//   }

//   setupVariablesBeforeUpload() async {
//     var cp = await networkCaller.getUserCurrentLocation();
//     updatePacModel.lat = cp.latitude.toString();
//     updatePacModel.lan = cp.longitude.toString();
//     updatePacModel.ip = await networkCaller.getPublicIp();
//   }

//   checkCheckin() async {
//     hasCheckedIn = await networkCaller.checkInStatus();
//     setState(() {});
//   }

//   getAsync() async {
//     try {
//       checkCheckin();
//       log(widget.data.toJson().toString());
//       addpac = await networkCaller.getPac(widget.data.taskId);
//       updatePacModel.linkId = addpac!.link_id;
//       updatePacModel.taskStatusId = addpac!.task_status_id;
//       updatePacModel.taskstatus = addpac!.task_status;
//       updatePacModel.vtaskId = addpac!.v_task_id;

//       await networkCaller.getDynamicFormData();
//     } catch (e) {
//       log(e.toString());
//     }
//     if (mounted) setState(() {});
//   }

//   getName(id) {
//     return networkCaller.dynamicSelector!
//         .firstWhere((element) => element.productId == id)
//         .name;
//   }

//   getPrice(id) {
//     return networkCaller.dynamicSelector!
//         .firstWhere((element) => element.productId == id)
//         .price;
//   }

//   bool createQuote = false;
//   getbody() {
//     if (networkCaller.dynamicSelector == null)
//       return Center(
//           child: CircularProgressIndicator(backgroundColor: Colors.orange));
//     else {
//       if (networkCaller.dynamicSelector!.isEmpty)
//         return Center(child: Text("No data available"));
//       else
//         return ListView(
//           children: [
//             if (updatePacModel.productList?.isNotEmpty ?? false)
//               Card(
//                 child: Column(children: [
//                   for (var plist in updatePacModel.productList!)
//                     Stack(
//                       children: [
//                         Card(
//                           child: ListTile(
//                             title: Text(getName(plist.productId) ?? ""),
//                             subtitle: createQuote
//                                 ? Text("Rate " +
//                                     getPrice(plist.productId) +
//                                     " || " +
//                                     plist.totalPrice)
//                                 : null,
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 if (createQuote) ...[
//                                   IconButton(
//                                       onPressed: () {
//                                         if (plist.quantity == null) {
//                                           plist.quantity = 1;
//                                         } else {
//                                           plist.quantity = plist.quantity! + 1;
//                                         }
//                                         setState(() {});
//                                       },
//                                       icon: const Icon(
//                                         Icons.add,
//                                         color: Colors.green,
//                                       )),
//                                   IconButton(
//                                       onPressed: plist.quantity == null
//                                           ? null
//                                           : () {
//                                               if (plist.quantity == 0) {
//                                                 return;
//                                               } else {
//                                                 plist.quantity =
//                                                     plist.quantity! - 1;
//                                               }
//                                               setState(() {});
//                                             },
//                                       icon: const Icon(
//                                         Icons.remove,
//                                         color: Colors.red,
//                                       ))
//                                 ],
//                                 IconButton(
//                                     onPressed: () {
//                                       updatePacModel.productList?.remove(plist);
//                                       setState(() {});
//                                     },
//                                     icon: const Icon(
//                                       Icons.delete,
//                                       color: Colors.red,
//                                     )),
//                               ],
//                             ),
//                           ),
//                         ),
//                         if (createQuote)
//                           Positioned(
//                               top: 10,
//                               right: 10,
//                               child: Text(
//                                 "x${plist.quantity ?? 0}",
//                                 style: TextStyle(color: Appcolors.primary2),
//                               ))
//                       ],
//                     ),
//                   Divider(),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Text("Grand Total",
//                             style: TextStyle(
//                                 color: Appcolors.primary2,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold)),
//                         Spacer(),
//                         Text(updatePacModel.totalPrice,
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold))
//                       ],
//                     ),
//                   )
//                 ]),
//               ),
//             DropdownButtonFormField(
//                 value: dynamicSelector,
//                  decoration: InputDecoration(
//                       isDense: true,
//                       // hintText: "Message" ,
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
//                       hintStyle: TextStyle(
//                         fontFamily: 'DM Sans',
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
                        
//                       ),
                      
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         // borderSide: BorderSide(color: Colors.grey.shade200),
//                         borderSide: BorderSide(color: Color(0XFFE2E2E2)),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         // borderSide: BorderSide(color: Colors.grey.shade400),
//                         borderSide: BorderSide(color: Color(0XFFE2E2E2)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.grey),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.red),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.red),
//                       ),
//                       errorStyle: TextStyle(
//                         fontFamily: 'DM Sans',
//                         fontSize: 11,
//                         color: Colors.red,
//                       ),
//                       label: Text("Select"),),
//                 // decoration: InputDecoration(
//                 //     border: OutlineInputBorder(), label: Text("Select")),
//                 items: [
//                   ...networkCaller.dynamicSelector!
//                       .map<DropdownMenuItem<DynamicSelector>>(
//                           (e) => DropdownMenuItem(
//                                 child: Text(e.name ?? "-"),
//                                 value: e,
//                               ))
//                       .toList()
//                 ],
//                 onChanged: (value) {
//                   dynamicSelector = value;
//                   productList = ProductList(
//                       productId: value!.productId!,
//                       vendorId: updatePacModel.vendorId,
//                       employeeId: networkCaller.getUser()!.employeeId,
//                       taskId: widget.data.taskId,
//                       instyes: "1",
//                       vTaskId: addpac!.v_task_id,
//                       firstName: updatePacModel.firstName,
//                       paccsName: widget.data.subject,
//                       message: "",
//                       taskstatus: addpac!.task_status,
//                       taskstatusId: addpac!.task_status_id,
//                       option: []);
//                   opyion = {};
//                   setState(() {});
//                 },
              
//             ),
//             if (dynamicSelector != null && dynamicSelector!.option != null) ...[
//               for (var option in dynamicSelector!.option!)
//                 if (option.type == "text")
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       onChanged: (val) {
//                         FieldOption fieldOption = FieldOption(
//                             productOptionId: option.productOptionId,
//                             optionId: option.optionId,
//                             productOptionValueId: "",
//                             name: option.name,
//                             type: option.type,
//                             value: val.trim());
//                         opyion[fieldOption] = val.trim();
//                         log(opyion.toString());
//                         setState(() {});
//                       },
//                        decoration: InputDecoration(
//                       isDense: true,
//                       // hintText: "Message" ,
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 12, vertical: 10.0),
//                       hintStyle: TextStyle(
//                         fontFamily: 'DM Sans',
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
                        
//                       ),
                      
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         // borderSide: BorderSide(color: Colors.grey.shade200),
//                         borderSide: BorderSide(color: Color(0XFFE2E2E2)),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         // borderSide: BorderSide(color: Colors.grey.shade400),
//                         borderSide: BorderSide(color: Color(0XFFE2E2E2)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.grey),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.red),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.red),
//                       ),
//                       errorStyle: TextStyle(
//                         fontFamily: 'DM Sans',
//                         fontSize: 11,
//                         color: Colors.red,
//                       ),
//                       label: Text(option.name ?? "-")),
//                       // decoration: InputDecoration(
//                       //     border: OutlineInputBorder(),
//                       //     label: Text(option.name ?? "-")),
//                     ),
//                   )
//                 else if (option.type == "select" &&
//                     option.productOptionValue != null)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: DropdownButtonFormField(
//                       key: ValueKey(option.name),
//                       // value: dynamicSelector,
//                        decoration: InputDecoration(
//                       isDense: true,
//                       // hintText: "Message" ,
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 12, vertical: 10.0),
//                       hintStyle: TextStyle(
//                         fontFamily: 'DM Sans',
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
                        
//                       ),
                      
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         // borderSide: BorderSide(color: Colors.grey.shade200),
//                         borderSide: BorderSide(color: Color(0XFFE2E2E2)),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         // borderSide: BorderSide(color: Colors.grey.shade400),
//                         borderSide: BorderSide(color: Color(0XFFE2E2E2)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.grey),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.red),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.red),
//                       ),
//                       errorStyle: TextStyle(
//                         fontFamily: 'DM Sans',
//                         fontSize: 11,
//                         color: Colors.red,
//                       ),
//                       label: Text(option.name ?? "-")),
//                       // decoration: InputDecoration(
//                       //     border: OutlineInputBorder(),
//                       //     label: Text(option.name ?? "-")),
//                       items: [
//                         ...option.productOptionValue!
//                             .map<DropdownMenuItem>((e) => DropdownMenuItem(
//                                   child: Text(e.name ?? "-"),
//                                   value: e,
//                                 ))
//                             .toList()
//                       ],
//                       onChanged: (value) {
//                         log(value.productOptionValueId);

//                         FieldOption fieldOption = FieldOption(
//                             productOptionId: option.productOptionId,
//                             optionId: option.optionId,
//                             productOptionValueId: value.productOptionValueId,
//                             name: option.name,
//                             type: option.type,
//                             value: value.name);
//                         opyion[fieldOption] = value.name;
//                         log(opyion.keys.first.productOptionValueId.toString());

//                         // dynamicSelector = value;
//                         setState(() {});
//                       },
//                     ),
//                   )
//                 else if (option.type == "date")
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       readOnly: true,
//                       controller: dateCon,
//                       onTap: () async {
//                         var dt = await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate:
//                                 DateTime.now().subtract(Duration(days: 1000)),
//                             lastDate: DateTime.now().add(Duration(days: 1000)));
//                         if (dt != null) {
//                           dateCon.text =
//                               DateFormat("yyyy-MM-dd HH:mm:ss").format(dt);
//                           FieldOption fieldOption = FieldOption(
//                               productOptionId: option.productOptionId,
//                               optionId: option.optionId,
//                               productOptionValueId: "",
//                               name: option.name,
//                               type: option.type,
//                               value: dateCon.text);
//                           opyion[fieldOption] = dateCon.text;
//                           setState(() {});
//                         }
//                       },
//                        decoration: InputDecoration(
//                       isDense: true,
//                       // hintText: "Message" ,
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 12, vertical: 10.0),
//                       hintStyle: TextStyle(
//                         fontFamily: 'DM Sans',
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
                        
//                       ),
                      
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         // borderSide: BorderSide(color: Colors.grey.shade200),
//                         borderSide: BorderSide(color: Color(0XFFE2E2E2)),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         // borderSide: BorderSide(color: Colors.grey.shade400),
//                         borderSide: BorderSide(color: Color(0XFFE2E2E2)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.grey),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.red),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.red),
//                       ),
//                       errorStyle: TextStyle(
//                         fontFamily: 'DM Sans',
//                         fontSize: 11,
//                         color: Colors.red,
//                       ),
//                       label: Text(option.name ?? "-")),
//                       // decoration: InputDecoration(
//                       //     border: OutlineInputBorder(),
//                       //     label: Text(option.name ?? "-")),
//                     ),
//                   )
//                 else
//                   SizedBox(),
//             ],
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 maxLines: 3,
//                 controller: mCon,
//                 onChanged: (val) {
//                   productList?.message = val.trim();
//                 },
//                  decoration: InputDecoration(
//                       isDense: true,
//                       hintText: "Message" ,
//                       contentPadding:
//                           EdgeInsets.symmetric(horizontal: 12, vertical: 10.0),
//                       hintStyle: TextStyle(
//                         fontFamily: 'DM Sans',
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
                        
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         // borderSide: BorderSide(color: Colors.grey.shade200),
//                         borderSide: BorderSide(color: Color(0XFFE2E2E2)),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         // borderSide: BorderSide(color: Colors.grey.shade400),
//                         borderSide: BorderSide(color: Color(0XFFE2E2E2)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.grey),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.red),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Colors.red),
//                       ),
//                       errorStyle: TextStyle(
//                         fontFamily: 'DM Sans',
//                         fontSize: 11,
//                         color: Colors.red,
//                       ),)
                      
//                 // decoration: InputDecoration(
//                 //     border: OutlineInputBorder(), label: Text("Message")),
//               ),
//             ),
//             SwitchListTile(
//               value: createQuote,
//               onChanged: (v) {
//                 createQuote = v;
//                 setState(() {});
//               },
//               title: Text("Create Quote"),
//             ),
//             if (createQuote)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: shipingCost,
//                   onChanged: (val) {
//                     updatePacModel.shippingCost = val.trim();
//                     setState(() {});
//                   },
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       label: Text("Shipping Cost")),
//                 ),
//               ),
//             Row(
//               children: [
//                 if (photo != null)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(photo.name),
//                   ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               photo != null ? Colors.red : Colors.green),
//                       onPressed: () async {
//                         if (photo != null) {
//                           photo = null;
//                         } else
//                           photo = await ImagePicker().pickImage(
//                               source: ImageSource.gallery,
//                               requestFullMetadata: true,
//                               imageQuality: 50);

//                         setState(() {});
//                       },
//                       icon: Icon(
//                           photo != null ? Icons.delete : Icons.attach_file),
//                       label: Text(photo != null ? "Remove" : "Attach ")),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ElevatedButton.icon(
//                       onPressed: dynamicSelector == null
//                           ? null
//                           : () {
//                               log(opyion.toString());

//                               productList!.option = opyion.keys.toList();
//                               productList!.price =
//                                   getPrice(productList!.productId);
//                               updatePacModel.productList!.add(productList!);
//                               dynamicSelector = null;
//                               opyion = {};
//                               dateCon.clear();
//                               updatePacModel.shippingCost =
//                                   shipingCost.text.trim();
//                               log("updatePacModel: " +
//                                   updatePacModel.toJson().toString());
//                               setState(() {});
//                             },
//                       icon: const Icon(Icons.add),
//                       label: Text("Add")),
//                 ),
//               ],
//             ),
//             FractionallySizedBox(
//               widthFactor: .5,
//               child: ElevatedButton(
//                   onPressed: updatePacModel.productList!.isNotEmpty
//                       ? () async {
//                           // EasyLoading.show();
//                           if (photo != null) {
//                             var res = await networkCaller
//                                 .uploadAttachment(photo.path);
//                             updatePacModel.attachname = photo.name;
//                             updatePacModel.attachpath =
//                                 res["data"]["location1"];
//                           }
//                           await setupVariablesBeforeUpload();
//                           log("updatePacModel setupVariablesBeforeUpload: " +
//                               updatePacModel.toJson().toString());

//                           await networkCaller.updateThePac(updatePacModel);
//                           // EasyLoading.dismiss();
//                           Navigator.pop(context);
//                         }
//                       : null,
//                   child: Text("Update")),
//             )
//           ],
//         );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         floatingActionButton:
//             !networkCaller.isAdminMode && hasCheckedIn != null && addpac != null
//                 ? FloatingActionButton.extended(
//                     backgroundColor: hasCheckedIn! ? Colors.red : Colors.green,
//                     onPressed: () async {
//                       // EasyLoading.show();
//                       await networkCaller.checkin(hasCheckedIn! ? 0 : 1,
//                           widget.data.taskId, addpac!.v_task_id);
//                       await checkCheckin();
//                       // EasyLoading.dismiss();
//                     },
//                     label: Text(hasCheckedIn! ? "Checkout" : "Checkin"))
//                 : null,
//         appBar: AppBar(
//           title: const Text('Update Task'),
//         ),
//         body: getbody());
//   }
// }



// Assuming these are your data models and utility classes
// Ensure these paths are correct for your project

// Make sure your DynamicSelectorOption and ProductOptionValue models match this structure
// (as inferred from your original code and the requirement for productOptionValue)
/*
// Example structure for your models/dynamic_selector.dart
class DynamicSelector {
  String? productId;
  String? name;
  String? price;
  List<DynamicSelectorOption>? option;

  DynamicSelector({this.productId, this.name, this.price, this.option});

  factory DynamicSelector.fromJson(Map<String, dynamic> json) => DynamicSelector(
        productId: json["product_id"],
        name: json["name"],
        price: json["price"],
        option: json["option"] == null
            ? []
            : List<DynamicSelectorOption>.from(json["option"]!.map((x) => DynamicSelectorOption.fromJson(x))),
      );
  // ... toJson method
}

// class DynamicSelectorOption {
//   String? productOptionId;
//   String? optionId;
//   String? name;
//   String? type; // "text", "select", "date"
//   List<ProductOptionValue>? productOptionValue; // Crucial for 'select' type

//   DynamicSelectorOption({
//     this.productOptionId,
//     this.optionId,
//     this.name,
//     this.type,
//     this.productOptionValue,
//   });

//   factory DynamicSelectorOption.fromJson(Map<String, dynamic> json) => DynamicSelectorOption(
//         productOptionId: json["product_option_id"],
//         optionId: json["option_id"],
//         name: json["name"],
//         type: json["type"],
//         productOptionValue: json["product_option_value"] == null
//             ? []
//             : List<ProductOptionValue>.from(json["product_option_value"]!.map((x) => ProductOptionValue.fromJson(x))),
//       );
//   // ... toJson method
// }

class ProductOptionValue {
  String? productOptionValueId;
  String? name;

  ProductOptionValue({this.productOptionValueId, this.name});

  factory ProductOptionValue.fromJson(Map<String, dynamic> json) => ProductOptionValue(
        productOptionValueId: json["product_option_value_id"],
        name: json["name"],
      );
  // ... toJson method
}
*/