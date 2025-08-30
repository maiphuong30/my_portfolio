import 'package:flutter/material.dart';

class HomeSection extends StatefulWidget {
  final VoidCallback onViewWork;   // scroll tới Projects
  final VoidCallback onContact;    // scroll tới Contact
  final VoidCallback onScrollDown; // scroll xuống tiếp section dưới

  const HomeSection({
    super.key,
    required this.onViewWork,
    required this.onContact,
    required this.onScrollDown,
  });

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.2), // nhún xuống 20%
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFollowMe({bool center = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
        width: double.infinity, // full width
        child: Row(
          mainAxisAlignment:
          center ? MainAxisAlignment.center : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Follow Me",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.facebook, color: Colors.blue),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.linked_camera, color: Colors.purple),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.alternate_email, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      height: isMobile ? 750 : 650,
      color: Colors.blue[50],
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Nội dung chính: responsive
          isMobile
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo lên trên
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/testImg.png", // Đường dẫn tới ảnh của bạn
                    width: 100, // chiều rộng
                    height: 100, // chiều cao
                    fit: BoxFit.contain, // giữ tỉ lệ ảnh
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Text + Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Hi, I'm Phương 👋",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "A passionate developer who loves building beautiful apps.",
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: widget.onViewWork,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "View My Work",
                          style: TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: widget.onContact,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          side: const BorderSide(
                              color: Colors.blue, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Get in touch",
                          style: TextStyle(
                              fontSize: 16, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  // Follow Me (center trên mobile)
                  _buildFollowMe(center: true),
                ],
              ),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bên trái: text + button
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hi, I'm Phương 👋",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "A passionate developer who loves building beautiful apps.",
                      style: TextStyle(
                          fontSize: 18, color: Colors.black54),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: widget.onViewWork,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "View My Work",
                            style: TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: widget.onContact,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            side: const BorderSide(
                                color: Colors.blue, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Get in touch",
                            style: TextStyle(
                                fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    // Follow Me (căn trái trên desktop)
                    _buildFollowMe(),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // Bên phải: logo Flutter
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/testImg.png", // Đường dẫn tới ảnh của bạn
                    width: 140, // chiều rộng
                    height: 140, // chiều cao
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),

          // Scroll Down + mũi tên nhún
          Positioned(
            bottom: 20,
            child: InkWell(
              onTap: widget.onScrollDown,
              borderRadius: BorderRadius.circular(16),
              child: SlideTransition(
                position: _offsetAnimation,
                child: Column(
                  children: const [
                    Text(
                      "Scroll Down",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down,
                        size: 32, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
