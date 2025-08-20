import 'dart:ui';

import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/tools/tools.dart';
import 'package:portfolio/widgets/messages.dart';

import '../../../backend/services.dart';
import '../../../provider.dart';
import '../../../theme/theme_data.dart';
import '../../../widgets/form.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key, required this.t});
  final theme t;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late theme t;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final Provider provider = Get.find<Provider>();
  bool isSending = false;

  final List<String> _sources = [
    "AI",
    "Search Engine",
    "YouTube",
    "Steam",
    "Reddit",
    "Twitter/X",
    "LinkedIn",
    "GitHub",
    "Friend/Colleague",
    "Other",
  ];
  String? _selectedSource;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    t = widget.t;
  }
  @override
  Widget build(BuildContext context) {
    bool landscape = isLandscape(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Obx(() {
        t = getTheme(provider);
        return Column(
            crossAxisAlignment:
            landscape ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Let's work together ",
                    style: GoogleFonts.getFont(
                      'Jersey 10',
                      fontSize: landscape ? 60 : 40,
                      fontWeight: FontWeight.bold,
                      color: t.accentColor,
                    ),
                    textAlign: landscape ? TextAlign.start : TextAlign.center,
                  ),
                  SvgPicture.asset(
                    "assets/icons/pixelHeart.svg",
                    width: 50,
                    color:Color(0xFFFA6767),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              landscape?Row(
                children: [
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 600, // adjust to your desired max width
                        ),
                        child: form(t),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  SizedBox(width: screenWidth*0.7*0.3 ,child:IntrinsicWidth(
                    child: Column(
                      children: [
                        socialIcons(t),
                        const SizedBox(height: 12),
                        portfolioCard(t),
                      ],
                    ),
                  )
                  )
                ],
              ):Column(
                children: [
                  form(t),
                  const SizedBox(height: 50),
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch, // children fill IntrinsicWidth
                      children: [
                        socialIcons(t),
                        const SizedBox(height: 12),
                        portfolioCard(t),
                      ],
                    ),
                  )


                ],
              ),
            ],
          );})
      ),
    ));
  }

  form(theme t){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          TextFormField(
            controller: _nameController,
            style: TextStyle(color: t.textColor), // 👈 input text color
            decoration: InputDecoration(
              labelText: "Name",
              labelStyle: TextStyle(color: t.textColor), // 👈 label color
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Enter your name";
              } else if (value.trim().length < 2) {
                return "Name must be at least 2 characters";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email
          TextFormField(
            controller: _emailController,
            style: TextStyle(color: t.textColor), // 👈 input text color
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(color: t.textColor), // 👈 label color
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Enter your email";
              }
              final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
              if (!emailRegex.hasMatch(value.trim())) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Source dropdown
          DropdownButtonFormField<String>(
            value: _selectedSource,
            style: TextStyle(color: t.textColor), // 👈 text color inside field
            decoration: InputDecoration(
              labelText: "Where did you discover my work?",
              labelStyle: TextStyle(color: t.textColor), // 👈 label color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: _sources.map((source) {
              return DropdownMenuItem(
                value: source,
                child: Text(
                  source,
                  style: TextStyle(color: t.textColor), // 👈 dropdown menu items color
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedSource = value),
            validator: (value) =>
            value == null ? "Please select a source" : null,
          ),

          const SizedBox(height: 16),

          // Message
          TextFormField(
            controller: _messageController,
            maxLines: 5,
            style: TextStyle(color: t.textColor), // 👈 set text color
            decoration: const InputDecoration(
              labelText: "Message",
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Enter your message";
              } else if (value.trim().length < 10) {
                return "Message must be at least 10 characters";
              }
              return null;
            },
          ),

          const SizedBox(height: 20),
          CustomButton(
            t: t,
            icon: "contact",
            text: "Send",
            onPressed: () async{
              setState(() {
                isSending = true;
              });
              bool result = false;
              if (_formKey.currentState!.validate()) {
                // Handle send action
                final supabaseService = SupabaseService();

                result  = await supabaseService.sendMessage(
                  name: _nameController.text,
                  email: _emailController.text,
                  source: _selectedSource??"",
                  message: _messageController.text,
                );

                if(result){
                  showSuccess("Message sent!", context);

                  // Clear the inputs
                  _nameController.clear();
                  _emailController.clear();
                  _messageController.clear();
                  setState(() {
                    _selectedSource = null;
                  });
                }
                else{
                  showError("Error while sending message", context);
                }
              }

              setState(() {
                isSending = false;
              });
            },
            isLoading: isSending,
            isFullRow: false,
          ),
        ],
      ),
    );
  }
  Widget socialIcons(theme t) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // glass blur
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  t.accentColor.withOpacity(0.25),
                  t.accentColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              children: [
                // Email
                IconButton(
                  icon: const Icon(Icons.alternate_email),
                  color: t.accentColor,
                  iconSize: 30,
                  onPressed: () {
                    EasyLauncher.url(
                      url: 'mailto:azizbalti.dev@gmail.com?subject=${Uri.encodeComponent('Hello aziz')}',
                    );
                  },
                ),
                // Twitter
                IconButton(
                  icon: const Icon(FontAwesomeIcons.xTwitter),
                  color: t.accentColor,
                  iconSize: 30,
                  onPressed: () {
                    EasyLauncher.url(
                        url:  "https://x.com/AzizBalti_"
                    );
                  },
                ),
                // Threads
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.threads), // placeholder for Threads
                  color: t.accentColor,
                  iconSize: 30,
                  onPressed: () {
                    EasyLauncher.url(
                        url:  "https://www.threads.com/@azizbalti_"
                    );
                  },
                ),
                // LinkedIn
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.linkedin),
                  color: t.accentColor,
                  iconSize: 30,
                  onPressed: () {
                    EasyLauncher.url(
                        url:  "https://www.linkedin.com/in/aziz-balti/"
                    );
                  },
                ),
                // YouTube
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.youtube),
                  color: t.accentColor,
                  iconSize: 30,
                  onPressed: () {
                    showMsg("We don't have a youtube channel for now", context, t);
                  },
                ),
                // TikTok
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.tiktok),
                  color: t.accentColor,
                  iconSize: 30,
                  onPressed: () {
                    showMsg("We don't have a tiktok for now", context, t);
                  },
                ),

                // Ko-fi
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.coffee),
                  color: t.accentColor,
                  iconSize: 30,
                  onPressed: () {
                    showMsg("We don't have a Ko-fi for now", context, t);
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.itchIo),
                  color: t.accentColor,
                  iconSize: 30,
                  onPressed: () {
                    EasyLauncher.url(
                        url:  "https://azizb.itch.io/"
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget portfolioCard(theme t) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  t.accentColor.withOpacity(0.25),
                  t.accentColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: t.accentColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "If you want to know more about me, check is my main portfolio",
                  style: TextStyle(
                    color: t.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FittedBox(
                  child:CustomButton(
                    t: t,
                    icon: "launch",
                    text: "Main Portfolio",
                    onPressed: () async{
                      await EasyLauncher.url(
                        url: "https://azizbalti.netlify.app/",
                      );
                    },
                    isLoading: false,
                    isFullRow: false,
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

}

class DiscoverSelect extends StatefulWidget {
  @override
  _DiscoverSelectState createState() => _DiscoverSelectState();
}
class _DiscoverSelectState extends State<DiscoverSelect> {
  final List<String> _sources = [
    "AI",
    "Search Engine",
    "YouTube",
    "Steam",
    "Reddit",
    "Twitter/X",
    "LinkedIn",
    "GitHub",
    "Friend/Colleague",
    "Other",
  ];

  String? _selectedSource;
  final Provider provider = Get.find<Provider>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      theme t = getTheme(provider);
      return DropdownButtonFormField<String>(
      value: _selectedSource,
      decoration: InputDecoration(
        labelText: "Where did you discover my work?",
      ),
      items: _sources.map((source) {
        return DropdownMenuItem(
          value: source,
          child: Text(source,style: TextStyle(color: t.textColor),),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedSource = value;
        });
      },
    );});
  }
}
