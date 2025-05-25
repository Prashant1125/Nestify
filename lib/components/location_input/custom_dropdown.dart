import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:home_for_rent/controller/custom_dropdown_contoller.dart';

class CustomExpandedDropdown extends StatefulWidget {
  final ExpandedDropdownController controller;
  final String hintText;
  final String? title;
  final double buttonWidth;
  final double buttonHeight;
  final List<String> listOfItems;
  final List<String> listOfItemsUniqueId;
  final FormFieldValidator<String>? validator;

  const CustomExpandedDropdown({
    super.key,
    required this.controller,
    required this.buttonWidth,
    this.hintText = "Select an option",
    required this.buttonHeight,
    required this.listOfItems,
    required this.listOfItemsUniqueId,
    this.title,
    this.validator, // Validator पैरामीटर
  });

  @override
  State<CustomExpandedDropdown> createState() => _CustomExpandedDropdownState();
}

class _CustomExpandedDropdownState extends State<CustomExpandedDropdown> {
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator, // Validator को Apply किया
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null)
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.title!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.0,
                    color: Colors.grey[900],
                  ),
                ),
              ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                widget.controller.toggleDropdown();
              },
              child: Obx(() => Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.controller.roleSelected.value.isEmpty
                              ? widget.hintText
                              : widget.controller.roleSelected.value,
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 12,
                          ),
                        ),
                        Icon(
                          widget.controller.isOpen.value
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey[900],
                        ),
                      ],
                    ),
                  )),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: widget.controller.isOpen.value ? 200 : 0,
                  child: widget.controller.isOpen.value
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Scrollbar(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: widget.listOfItems.length,
                              itemBuilder: (context, index) {
                                final String option = widget.listOfItems[index];

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: InkWell(
                                    onTap: () {
                                      widget.controller.selectOption(option);
                                      widget.controller.toggleDropdown();
                                      field.didChange(
                                          option); // Update Validation
                                    },
                                    child: Obx(() {
                                      final bool isSelected =
                                          widget.controller.isSelected(option);
                                      return AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 100),
                                        width: widget.buttonWidth,
                                        height: widget.buttonHeight,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.transparent
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: isSelected
                                              ? Border.all(
                                                  color: Colors.teal,
                                                  width: 1.5)
                                              : Border.all(
                                                  color: Colors.transparent,
                                                  width: 0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              isSelected ? 2.5 : 4),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 100),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                              child: Text(
                                                option,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: isSelected
                                                      ? Colors.teal
                                                      : Colors.grey[900],
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : const SizedBox(),
                )),
          ],
        );
      },
    );
  }
}
