import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray300,
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: "Tìm kiếm phòng trọ...",
          hintStyle: TextStyle(color: AppColors.gray400),
          prefixIcon: Icon(Icons.search, color: AppColors.gray500),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(Icons.tune, color: AppColors.gray500),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      );
  }
}