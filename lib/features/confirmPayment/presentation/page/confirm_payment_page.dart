import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_book_access/core/api/api_endpoints.dart';
import 'package:smart_book_access/core/utils/snackbar_utils.dart';
import 'package:smart_book_access/core/widgets/my_button.dart';
import 'package:smart_book_access/features/book/domain/entities/book_entity.dart';
import 'package:smart_book_access/features/confirmPayment/domain/entities/confirm_payment_entity.dart';
import 'package:smart_book_access/features/confirmPayment/presentation/state/confirm_payment_state.dart';
import 'package:smart_book_access/features/confirmPayment/presentation/view_model/confirm_payment_view_model.dart';

class ConfirmPaymentPage extends ConsumerStatefulWidget {
  final BookEntity book;

  const ConfirmPaymentPage({super.key, required this.book});

  @override
  ConsumerState<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends ConsumerState<ConfirmPaymentPage> {
  DateTime? _selectedDate;
  int _numberOfDays = 0;
  final DateTime _rentedDate = DateTime.now();

  void _calculateDays(DateTime selectedDate) {
    final cleanToday = DateTime(_rentedDate.year, _rentedDate.month, _rentedDate.day);
    final cleanSelected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    final diff = cleanSelected.difference(cleanToday).inDays + 1;
    setState(() {
      _selectedDate = selectedDate;
      _numberOfDays = diff > 0 ? diff : 0;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _rentedDate.add(const Duration(days: 1)),
      firstDate: _rentedDate,
      lastDate: _rentedDate.add(const Duration(days: 365)),
    );
    if (picked != null) {
      _calculateDays(picked);
    }
  }

  DateTime _toEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  void _handleConfirmPayment() {
    if (_selectedDate == null) {
      return SnackbarUtils.showError(context, "Please select an expiry date");
    }

    final book = widget.book;
    final expiresAtEndOfDay = _toEndOfDay(_selectedDate!);

    final rental = RentalEntity(
      userId: "",
      bookId: book.bookId ?? '',
      bookTitle: book.title,
      bookAuthor: book.author,
      bookImageUrl: book.coverImageUrl,
      price: book.price.toDouble(),
      expiresAt: expiresAtEndOfDay.toIso8601String(),
    );

    ref.read(confirmPaymentViewModelProvider.notifier).rentBook(rental);
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final state = ref.watch(confirmPaymentViewModelProvider);

    ref.listen<ConfirmPaymentState>(confirmPaymentViewModelProvider, (previous, next) {
      if (next.status == ConfirmPaymentStatus.success) {
        SnackbarUtils.showSuccess(context, "Book rented successfully!");
        Navigator.pop(context);
      } else if (next.status == ConfirmPaymentStatus.error) {
        SnackbarUtils.showError(context, next.errorMessage ?? "Rental failed");
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Confirm Payment",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Image.network(
                    '${ApiEndpoints.serverUrl}${book.coverImageUrl}',
                    height: 100,
                    width: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.book, size: 50),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          book.author,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Rented Date",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('yyyy-MM-dd').format(_rentedDate),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            const Text(
              "Expiry Date",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _selectedDate == null
                    ? "Select Date"
                    : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                style: const TextStyle(fontSize: 16),
              ),
              trailing: const Icon(Icons.calendar_today, color: Colors.blue, size: 22),
              onTap: _selectDate,
            ),
            Text(
              "Total Duration: $_numberOfDays ${_numberOfDays == 1 ? "Day" : "Days"}",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const Divider(height: 40, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rs. ${book.price.toInt()}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: MyButton(
                text: "CONTINUE & PAY",
                onPressed: _handleConfirmPayment,
                isLoading: state.status == ConfirmPaymentStatus.loading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}