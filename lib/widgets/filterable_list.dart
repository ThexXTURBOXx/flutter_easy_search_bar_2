// Copyright 2021 4inka

// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:

// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.

// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.

// 3. Neither the name of the copyright holder nor the names of its contributors
// may be used to endorse or promote products derived from this software without
// specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';

/// Widget that shows a filterable list (useful for dropdowns)
class FilterableList<T> extends StatelessWidget {
  /// The items to filter
  final List<T> items;

  /// Function that is called when a given item is tapped
  final Function(T) onItemTapped;

  /// Maximum height of the list
  final double maxListHeight;

  /// [TextStyle] that is used for the suggestions in the list
  final TextStyle suggestionTextStyle;

  /// Widget that is shown while the list is loading
  final Widget? loader;

  /// Background color behind the suggestions
  final Color? suggestionBackgroundColor;

  /// Is the list currently loading?
  final bool loading;

  /// Function translating a given suggestion to a Widget
  final Widget Function(T data)? suggestionBuilder;

  /// Function translating a given suggestion to a String (used if
  /// [suggestionBuilder] is not given)
  final String Function(T data)? suggestionToString;

  /// Construct a new filterable list instance
  const FilterableList({
    super.key,
    required this.items,
    required this.onItemTapped,
    this.loader,
    this.suggestionBuilder,
    this.maxListHeight = 150,
    this.suggestionTextStyle = const TextStyle(),
    this.suggestionBackgroundColor,
    this.suggestionToString,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaffold = Scaffold.maybeOf(context);

    final suggestionBackgroundColor = this.suggestionBackgroundColor ??
        scaffold?.widget.backgroundColor ??
        theme.scaffoldBackgroundColor;

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      color: suggestionBackgroundColor,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxListHeight),
        child: Visibility(
          visible: items.isNotEmpty || loading,
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(5),
            itemCount: loading ? 1 : items.length,
            itemBuilder: (context, index) {
              if (loading) {
                return loader!;
              }

              if (suggestionBuilder != null) {
                return InkWell(
                  child: suggestionBuilder!(items[index]),
                  onTap: () => onItemTapped(items[index]),
                );
              }

              final toString = suggestionToString ?? (s) => s.toString();

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      toString(items[index]),
                      style: suggestionTextStyle,
                    ),
                  ),
                  onTap: () => onItemTapped(items[index]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
