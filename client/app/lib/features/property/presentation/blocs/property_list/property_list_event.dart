part of 'property_list_bloc.dart';
sealed class PropertyListEvent extends Equatable { const PropertyListEvent(); @override List<Object> get props => []; }
final class PropertyListFetched extends PropertyListEvent { const PropertyListFetched(); }
