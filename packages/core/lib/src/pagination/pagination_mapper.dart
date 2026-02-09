import 'package:app_platform_core/core.dart';

abstract class PaginationMapper {
  Map<String, dynamic> toQuery(Pagination pagination);
}
