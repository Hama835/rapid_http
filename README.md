# rapid_http

`rapid_http` is a Dart package that provides a simple and efficient HTTP client for making HTTP requests. It includes features like request methods (GET, POST, PUT, DELETE, etc.), request headers, request bodies, response handling, caching, and network connectivity checking.

## Features

- Easy-to-use HTTP client for making HTTP requests.
- Supports common HTTP request methods like GET, POST, PUT, DELETE, etc.
- Ability to set default headers for each request.
- Caching functionality to store and retrieve responses from a temporary cache.
- Network connectivity checking to monitor the device's internet connectivity status.
- Well-documented code with clear usage examples.

## Installation

To use `rapid_http`, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  rapid_http: ^1.0.0
```
Then, run flutter pub get to fetch the package.

## Usage
Here's a quick example demonstrating how to use the RapidClient class to make HTTP requests:

```Dart
import 'package:rapid_http/rapid_http.dart';

void main() async {
  final client = RapidClient();
  
  final response = await client.get('https://api.example.com/data');
  
  if (response.statusCode == 200) {
    print('Response body: ${response.body}');
  } else {
    print('Request failed with status code: ${response.statusCode}');
  }
  
}
```

For more detailed information on how to use the package and its various features, please refer to the API documentation.

## Contributing
Contributions are welcome! If you encounter any issues, have suggestions, or would like to contribute to the project, please feel free to submit a pull request or open an issue on the GitHub repository.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
