import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather_app/my_app.dart';
import 'package:geolocator/geolocator.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Controller để lấy dữ liệu từ ô nhập email và password
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Cờ để xác định đang ở chế độ đăng nhập hay đăng ký
  bool isLogin = true;

  // Cờ để hiển thị loading khi đang xử lý firebase
  bool isLoading = false;

  // Màu nền, màu container và màu nhấn chính (accent color) cho UI
  final backgroundColor = const Color(0xFF121212);
  final containerColor = const Color(0xFF2C2C2C);
  final accentColor = Colors.tealAccent;

  // Hàm _submit được gọi khi người dùng nhấn nút "Đăng nhập" hoặc "Đăng ký"
  void _submit() async {
    // Lấy giá trị email và password từ ô nhập, đồng thời loại bỏ khoảng trắng thừa
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Kiểm tra đơn giản: nếu email rỗng hoặc password dưới 6 ký tự thì không làm gì
    if (email.isEmpty || password.length < 6) return;
    // Bật trạng thái loading
    setState(() => isLoading = true);
    try {
      UserCredential userCredential;
      // Nếu đang ở chế độ đăng nhập
      if (isLogin) {
        // Gọi Firebase để đăng nhập với email và password
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Lấy vị trí hiện tại của người dùng sau khi đăng nhập thành công
        final position = await Geolocator.getCurrentPosition();
        // Kiểm tra xem widget có còn nằm trong cây widget không
        if (!mounted) return;
        // Điều hướng người dùng sang màn hình chính (MyApp) và truyền vị trí hiện tại vào
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MyApp(positionCurrent: position),
          ),
        );
      } else {
        // Nếu đang ở chế độ đăng ký
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Sau khi đăng ký thành công, tạo document mới trong Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({'username': 'Tên mặc định'}); // Gán tên mặc định

        //Kiểm tra widget vẫn còn trên cây trước khi dùng context
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng ký thành công, hãy đăng nhập')),
        );

        // Chuyển lại sang chế độ đăng nhập
        setState(() {
          isLogin = true;
          isLoading = false;
        });

        // Xóa nội dung trong các ô nhập
        _emailController.clear();
        _passwordController.clear();

        // Kết thúc hàm nếu là đăng ký (không chạy phần dưới)
        return;
      }
    } on FirebaseAuthException catch (e) {
      // Bắt lỗi từ FirebaseAuth (sai tài khoản, mật khẩu, mạng...)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Lỗi xảy ra')),
      );
    } catch (_) {
      // Bắt lỗi không xác định khác
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi không xác định')),
      );
    } finally {
      // Tắt loading sau khi xử lý xong (nếu widget vẫn đang tồn tại)
      if (mounted && isLoading) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: SingleChildScrollView(
            key: ValueKey(isLogin),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLogin ? 'Chào mừng quay lại' : 'Tạo tài khoản mới',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.email_outlined, color: Colors.grey),
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: backgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.lock_outline, color: Colors.grey),
                      labelText: 'Mật khẩu',
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: backgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              isLogin ? 'Đăng nhập' : 'Đăng ký',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin
                          ? 'Chưa có tài khoản? Đăng ký'
                          : 'Đã có tài khoản? Đăng nhập',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
