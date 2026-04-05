import '../models/cart_item_model.dart';
import '../models/address_model.dart';

class CartMockDatasource {
  final List<CartItemModel> _items = [
    const CartItemModel(
      id: 'c1',
      productId: '2',
      name: 'Chicken Sharma',
      imageUrl: 'https://via.placeholder.com/200x200/FFCCBC/212121?text=Chicken',
      price: 140.00,
      originalPrice: 160.00,
      quantity: 1,
      variant: '1kg',
      storeName: 'ABC Farmer',
      storeId: 'store1',
    ),
    const CartItemModel(
      id: 'c2',
      productId: '7',
      name: 'Best Mix Eye Ball',
      imageUrl: 'https://via.placeholder.com/200x200/FFCCBC/212121?text=Eye+Ball',
      price: 349.00,
      quantity: 2,
      variant: '500g',
      storeName: 'Mama\'s',
      storeId: 'store2',
    ),
    const CartItemModel(
      id: 'c3',
      productId: '9',
      name: 'Lamb Meat',
      imageUrl: 'https://via.placeholder.com/200x200/FFCCBC/212121?text=Lamb',
      price: 345.00,
      quantity: 1,
      variant: '1kg',
      storeName: 'Mama\'s',
      storeId: 'store2',
    ),
    const CartItemModel(
      id: 'c4',
      productId: '15',
      name: 'Strawberry',
      imageUrl: 'https://via.placeholder.com/200x200/FFCCBC/212121?text=Strawberry',
      price: 346.00,
      originalPrice: 400.00,
      quantity: 1,
      variant: '250g',
      storeName: 'FruiShop',
      storeId: 'store3',
    ),
  ];

  final List<AddressModel> _addresses = [
    const AddressModel(
      id: 'a1',
      label: 'Home',
      fullName: 'John Doe',
      address: '384 Westheimer Rd, Richardson',
      city: 'San Francisco',
      state: 'CA',
      country: 'US',
      zipCode: '94102',
      phone: '(415) 555-0128',
      isDefault: true,
    ),
    const AddressModel(
      id: 'a2',
      label: 'Office',
      fullName: 'John Doe',
      address: 'Online Avenue, Van Francisco',
      city: 'San Francisco',
      state: 'CA',
      country: 'US',
      zipCode: '94103',
      phone: '(415) 555-0123',
    ),
  ];

  Future<List<CartItemModel>> getCartItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  Future<void> addItem(CartItemModel item) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _items.indexWhere((i) => i.productId == item.productId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }
  }

  Future<void> updateQuantity(String id, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(quantity: quantity);
    }
  }

  Future<void> removeItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _items.removeWhere((item) => item.id == id);
  }

  Future<double> applyCoupon(String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (code.toUpperCase() == 'SAVE10') return 10.0;
    if (code.toUpperCase() == 'SAVE20') return 20.0;
    return 0.0;
  }

  Future<List<AddressModel>> getAddresses() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_addresses);
  }

  Future<void> addAddress(AddressModel address) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _addresses.add(address);
  }

  Future<String> placeOrder() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _items.clear();
    return 'ORD-${DateTime.now().millisecondsSinceEpoch}';
  }
}
