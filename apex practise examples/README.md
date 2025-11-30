# Apex Practice Examples

A comprehensive collection of 500+ runnable Apex examples covering all major topics from the Salesforce Apex Developer Guide.

## 📚 Topics Covered

| # | Topic | Examples | Description |
|---|-------|----------|-------------|
| 01 | Fundamentals | 20+ | Classes, methods, variables, access modifiers |
| 02 | Data Types | 25+ | Primitives, sObjects, collections |
| 03 | Control Flow | 20+ | If/else, switch statements |
| 04 | Loops | 20+ | For, while, do-while loops |
| 05 | Operators | 20+ | Arithmetic, logical, relational |
| 06 | Collections | 30+ | Lists, Sets, Maps operations |
| 07 | Strings | 25+ | String methods and manipulation |
| 08 | SOQL | 40+ | Queries, relationships, aggregates |
| 09 | DML | 30+ | Insert, update, delete, upsert |
| 10 | Exception Handling | 20+ | Try/catch, custom exceptions |
| 11 | Triggers | 30+ | Before/after triggers, context |
| 12 | Batch Apex | 20+ | Database.Batchable interface |
| 13 | Queueable Apex | 15+ | Asynchronous processing |
| 14 | Scheduled Apex | 15+ | Schedulable interface |
| 15 | Future Methods | 15+ | @future annotation |
| 16 | Platform Events | 20+ | Event-driven architecture |
| 17 | Testing | 40+ | Test classes, assertions, mocks |
| 18 | Governor Limits | 25+ | Bulkification patterns |
| 19 | HTTP Callouts | 25+ | REST/SOAP integration |
| 20 | JSON/XML | 20+ | Parsing and serialization |
| 21 | Dynamic Apex | 25+ | Schema describe, reflection |
| 22 | Security | 20+ | Sharing, FLS, CRUD checks |
| 23 | Visualforce | 20+ | Controllers, extensions |
| 24 | Lightning Components | 20+ | Aura, LWC controllers |
| 25 | Apex Patterns | 25+ | Design patterns, best practices |

## 🚀 Getting Started

### Prerequisites
- Salesforce Developer Org (free at [developer.salesforce.com](https://developer.salesforce.com/signup))
- Salesforce CLI (`sf` or `sfdx`)
- VS Code with Salesforce Extensions

### Setup

1. **Authenticate to your org:**
```bash
sf org login web --alias myDevOrg
```

2. **Deploy examples:**
```bash
# Deploy all classes
sf project deploy start --source-dir "apex practise examples"

# Or deploy individual files
sf project deploy start --source-dir "apex practise examples/01-fundamentals"
```

3. **Run examples in Developer Console or Anonymous Apex:**
```bash
# Execute anonymous Apex
sf apex run --file "apex practise examples/01-fundamentals/01-basic-class.apex"
```

### Testing Examples

```bash
# Run all tests
sf apex run test --code-coverage --result-format human

# Run specific test class
sf apex run test --tests AccountTriggerTest --result-format human
```

## 📖 Learning Path

### Beginner
1. Start with **01-Fundamentals** and **02-Data-Types**
2. Move to **03-Control-Flow** and **04-Loops**
3. Practice **06-Collections** and **07-Strings**
4. Learn **08-SOQL** and **09-DML**

### Intermediate
1. Master **11-Triggers** and **10-Exception-Handling**
2. Explore **12-Batch-Apex** and **13-Queueable-Apex**
3. Understand **17-Testing** (critical!)
4. Study **18-Governor-Limits** patterns

### Advanced
1. Deep dive into **19-HTTP-Callouts**
2. Learn **21-Dynamic-Apex** and **22-Security**
3. Master **25-Apex-Patterns**
4. Build with **24-Lightning-Components**

## 🎯 Best Practices

- **Always write tests** - Aim for 100% code coverage
- **Bulkify your code** - Handle collections, not single records
- **Avoid SOQL/DML in loops** - Query and DML outside loops
- **Use proper exception handling** - Never catch generic Exception
- **Follow naming conventions** - PascalCase for classes, camelCase for methods
- **Respect governor limits** - Design for scale from day one

## 📝 Notes

- All examples are **production-ready** with proper error handling
- Test classes included for most examples
- Comments explain key concepts and gotchas
- Examples follow Salesforce best practices and design patterns

## 🔗 Resources

- [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)
- [Apex Reference Guide](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/)
- [Trailhead - Apex Basics](https://trailhead.salesforce.com/content/learn/modules/apex_database)
- [Salesforce CLI Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/)

## 📄 License

MIT License - Feel free to use these examples for learning and reference.

---

**Created:** November 2025  
**API Version:** 65.0 (Winter '26)  
**Total Examples:** 500+
