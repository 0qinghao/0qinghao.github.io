---
layout: post
title: C/C++ assert 自定义提示信息
categories: [C/C++]
description: 在开发过程中使用 assert 可以帮助定位问题，增强鲁棒性。我们可以使用一个小技巧在 assert 触发时同时输出预先定义好的提示信息，进一步帮助定位问题。
keywords: assert, 断言, 自定义提示信息
furigana: false
---

在 C/C++ 开发中，`assert` 是一个非常有用的工具。它可以在程序运行时进行条件检查，并在条件不满足时触发错误，帮助开发者定位问题。然而，默认的 `assert` 输出并不会给出太多有用的信息。本文将分享一个小技巧，帮助你在 `assert` 触发时输出自定义的提示信息，从而更快地定位问题。

# 示例代码
以下是一个简单的代码示例：

```c
#include <stdio.h>
#include <assert.h>

typedef unsigned char uint8;

void main()
{
    uint8 log2_cu_size = 5;

    // 常规的 assert 语句
    assert(5 > log2_cu_size && 2 < log2_cu_size);

    // 带自定义提示信息的 assert
    assert(("illegal CU size", 5 > log2_cu_size && 2 < log2_cu_size));

    printf("cu_size = %d", 1 << log2_cu_size);

    return;
}
```

在这段代码中，第一处 `assert` 是标准的用法，如果 CU 尺寸异常，程序会直接中断并输出默认的 `assert` 错误信息。

第二行 `assert` 使用了一个小技巧，在条件之前添加了一个字符串 `"illegal CU size"`，这样在条件不满足时会输出这段信息。

# 运行结果分析
假设运行上述代码时 `log2_cu_size = 5`，则第一行和第二行的断言都会失败。

- 对于第一处的 `assert`，输出类似：

```
assert_comment.c:8: main: Assertion `5 > log2_cu_size && 2 < log2_cu_size' failed.
```

- 对于第二处的 `assert`，输出会包含额外的提示信息：

```
assert_comment.c:9: main: Assertion `("illegal CU size", 5 > log2_cu_size && 2 < log2_cu_size)' failed.
```

# 技巧背后的原理
在 C/C++ 中，逗号表达式的结果是最后一个表达式的值。因此，`assert(("illegal CU size", 5 > log2_cu_size && 2 < log2_cu_size))` 实际上会忽略字符串 `"illegal CU size"`，只对 `5 > log2_cu_size && 2 < log2_cu_size` 进行断言检查。然而，字符串 `"illegal CU size"` 会被 `assert` 错误信息捕获并输出。

# 注意事项
1. **避免复杂提示信息**：提示信息应当简洁明了，便于快速理解问题所在。
2. **仅在开发环境使用**：`assert` 通常在 `Debug` 模式下使用。在 `Release` 模式中，建议移除断言检查以提升性能。
3. **搭配日志使用**：对于复杂的程序，建议结合日志记录系统一起使用，以便更全面地了解程序的运行情况。

# 总结
通过在 `assert` 语句中使用逗号表达式，我们可以轻松添加自定义提示信息。这种方法简单有效，可以显著提高程序调试效率。希望本文的分享对你的开发工作有所帮助！

如果你有其他关于 `assert` 的技巧，欢迎留言讨论。
