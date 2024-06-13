### Building the project
To build the project, you need to set up a local Configuration file to hold the API key needed to fetch data.

1. Retrieve an API key by following the instructions on https://developer.nytimes.com/get-started.
2. Create a `Config.xcconfig` file at the root of the `DataFetcher` directory with the following content:
```
API_KEY = <YOUR_API_KEY>
```

This is not the ideal way of managing API keys, but it does the job for this simple demo.

### Visuals

| Home | Article |
|----------|----------|
| ![Simulator Screenshot - iPhone 15 Pro - 2024-06-14 at 00 03 36](https://github.com/gustafguner/u6i-data-fetcher-app/assets/1573205/55663d41-2140-4634-8fe3-4e3a4f0a3f92)  | ![Simulator Screenshot - iPhone 15 Pro - 2024-06-14 at 00 03 41](https://github.com/gustafguner/u6i-data-fetcher-app/assets/1573205/bc4cd9e4-5412-491c-b0b5-17af08dfd0b7) |

