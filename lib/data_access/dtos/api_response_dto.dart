class ApiResponseDto<T> {
  // TODO enum
  final String status;
  final T data;

  const ApiResponseDto({
    required this.status,
    required this.data,
  });
}
