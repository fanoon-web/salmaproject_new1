import 'package:flutter/material.dart';

class ConditionFilterChips extends StatefulWidget {
  final String? selectedCondition;
  final ValueChanged<String?>? onConditionSelected;

  const ConditionFilterChips({
    super.key,
    this.selectedCondition,
    this.onConditionSelected,
  });

  @override
  State<ConditionFilterChips> createState() => _ConditionFilterChipsState();
}

class _ConditionFilterChipsState extends State<ConditionFilterChips> {
  final Map<String, String> conditions = {
    'new': 'New',
    'used': 'Used',
    'refurbished': 'Refurbished',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    double chipWidth = screenWidth * 0.25;
    double chipHeight = 40;
    double fontSize = 13;

    if (screenWidth > 800) {
      chipWidth = 180;
      chipHeight = 48;
      fontSize = 16;
    } else if (screenWidth < 350) {
      chipWidth = 100;
      chipHeight = 36;
      fontSize = 12;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16, top: 4),
      child: Row(
        children: conditions.entries.map((entry) {
          final conditionKey = entry.key;
          final label = entry.value;
          final isSelected = widget.selectedCondition == conditionKey;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                final newValue = isSelected ? null : conditionKey;
                if (widget.onConditionSelected != null) {
                  widget.onConditionSelected!(newValue);
                }
              },
              borderRadius: BorderRadius.circular(22),
              splashColor: theme.primaryColor.withAlpha(25),
              highlightColor: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: chipWidth,
                height: chipHeight,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.primaryColor.withAlpha(25)
                      : theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected
                        ? theme.primaryColor
                        : theme.focusColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    label,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: fontSize,
                      color: isSelected
                          ? theme.primaryColor
                          : theme.disabledColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
