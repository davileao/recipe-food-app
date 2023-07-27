import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/meal.dart';
import 'meal_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier([Map<Filter, bool>? initialFilters])
      : super(initialFilters ?? kInitialFilters);

  void toggleFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  void toggleFilter(Filter filter, bool isActive) {
    // state[filter] = isActive; // not allowed because state is immutable
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);


//adding a provider for the filteredMealList

final filteredMealsProvider = Provider<List<Meal>>((ref) {
  final activeFilters = ref.watch(filtersProvider);
  final meals = ref.watch(mealsProvider);

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


