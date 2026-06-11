# Hướng dẫn chạy test

## Unit Tests

Chạy tất cả unit test:
```bash
yarn test
```

Chạy unit test của một module:
```bash
yarn test --testPathPatterns "test/properties"
```

Chạy một file test cụ thể:
```bash
yarn test --testPathPatterns "create-properties.service"
```

Chạy unit test kèm coverage:
```bash
yarn test:cov
```

Chạy coverage cho một module cụ thể:
```bash
yarn test:cov --testPathPatterns "test/auth" --collectCoverageFrom "src/modules/auth/**/*.ts"
```

## E2E Tests

Chạy tất cả E2E test:
```bash
yarn test:e2e
```

Chạy E2E test của một module:
```bash
yarn test:e2e --testPathPatterns "properties.e2e"
```

Chạy E2E test kèm coverage:
```bash
yarn test:e2e --coverage
```
