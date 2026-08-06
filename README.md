# Hello World Flutter 应用

这是一个最小 Flutter 跨平台应用，启动后显示“我的第一个应用”和 `Hello World`。

## 在 Windows 电脑上运行

使用 Flutter 3.44.8 stable（不要使用 PATH 中的旧 master SDK）：

```powershell
$env:ANDROID_HOME = 'C:\Users\SE\AppData\Local\Android\Sdk'
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
$flutter = 'E:\code\auto\sdk\flutter_windows_3.44.8-stable\flutter\bin\flutter.bat'
& $flutter pub get
& $flutter run -d chrome
```

也可以直接打开已构建的 Web 版本：

```powershell
python -m http.server 8080 --directory build\web
```

然后访问 <http://localhost:8080>。

## 平台说明

- Android 工程位于 `android/`，由 Gradle 构建；Maven 只能作为依赖仓库或 Java 项目工具，不能替代 Flutter Android 构建所需的 Gradle。
- iOS 工程位于 `ios/`。生成 IPA 必须在 macOS 上安装 Xcode，并配置 Apple 开发者签名；Windows 不能直接编译或签名 IPA。
- `windows/` 和 `web/` 已生成，可分别用于 Windows 桌面和浏览器运行。Windows 桌面构建还需要 Visual Studio 的“Desktop development with C++”工作负载。

## 验证

```powershell
& $flutter analyze
& $flutter test
& $flutter build web
```

