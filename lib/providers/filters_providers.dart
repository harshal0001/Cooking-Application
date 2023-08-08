import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_receipe_app/providers/meals_providers.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifiers extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifiers()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });
  void setFilters(Filter filter, bool isActive) {
    // state[filter] = isActive; // Not Allowed because of mutating state
    state = {
      ...state,
      filter: isActive,
    };
  }

  void setAllFilters(Map<Filter, bool> chosenFilter) {
    state = chosenFilter;
  }
}

final filtersProviders =
    StateNotifierProvider<FiltersNotifiers, Map<Filter, bool>>(
        (ref) => FiltersNotifiers());

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProviders);
  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
