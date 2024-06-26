import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:taskify/app/core/utils/extensions.dart';
import 'package:taskify/app/modules/aria/bloc/chat_bloc.dart';
import 'package:taskify/app/modules/aria/models/chat_message_model.dart';
import 'package:taskify/app/modules/home/widgets/gradient_text.dart';

class AriaView extends StatefulWidget {
  const AriaView({super.key});

  @override
  State<AriaView> createState() => _AriaViewState();
}

class _AriaViewState extends State<AriaView> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.orange[500],
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: GradientText(
          "Aria",
          style: GoogleFonts.poppins(
              fontSize: 20.0.sp, fontWeight: FontWeight.w600),
          gradient: LinearGradient(
            colors: [
              Colors.red.shade200,
              Colors.pinkAccent,
            ],
          ),
        ),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              List<ChatMessageModel> messages =
                  (state as ChatSuccessState).messages;
              return Column(
                children: [
                  Expanded(
                    child: messages.isEmpty
                        ? Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child:
                                      Image.asset("assets/images/aria-ai.png"),
                                ),
                                const SizedBox(height: 28),
                                GradientText(
                                  "       Ask Aria anything about\npersonal tasks, work, shopping\n               or anything else!",
                                  style: GoogleFonts.poppins(
                                    fontSize: 10.0.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.black38,
                                      Colors.black45,
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 100),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 6,
                                      ),
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: messages[index].role == "user"
                                          ? const Icon(
                                              CupertinoIcons.person,
                                            )
                                          : Image.asset(
                                              "assets/images/aria-ai.png",
                                              scale: 12,
                                            ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 16,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.grey[200],
                                      ),
                                      child: Text(
                                        messages[index].parts.first.text,
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 12.0.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Colors.black38,
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Ask anything from Aria",
                              hintStyle: GoogleFonts.poppins(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (textEditingController.text.isNotEmpty) {
                                  String text = textEditingController.text;
                                  textEditingController.clear();

                                  chatBloc.add(ChatGenerateNewTextMessageEvent(
                                      inputMessage: text));
                                }
                              },
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  radius: 31,
                                  backgroundColor: Colors.white,
                                  child: chatBloc.generating
                                      ? Lottie.asset(
                                          "assets/images/loader.json",
                                        )
                                      : ShaderMask(
                                          shaderCallback: (bounds) =>
                                              LinearGradient(
                                            colors: [
                                              Colors.red.shade200,
                                              Colors.pinkAccent
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ).createShader(bounds),
                                          child: const Icon(
                                            CupertinoIcons.arrow_turn_up_right,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
