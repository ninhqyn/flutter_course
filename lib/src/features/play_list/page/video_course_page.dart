import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/src/features/my_course/bloc/my_course_bloc.dart';
import 'package:learning_app/src/features/my_course_detail/bloc/my_course_detail_bloc.dart';
import 'package:learning_app/src/features/play_list/bloc/play_list_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/shared/models/lesson.dart';
import 'package:learning_app/src/shared/models/module.dart';

class VideoCoursePage extends StatefulWidget {
  const VideoCoursePage({
    super.key,
    required this.courseId,
    required this.moduleId,
    required this.lessonId
  });

  final int courseId;
  final int moduleId;
  final int lessonId;

  @override
  State<VideoCoursePage> createState() => _VideoCoursePageState();
}

class _VideoCoursePageState extends State<VideoCoursePage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  Lesson? _currentLesson;
  List<Lesson> _lessons = [];
  Module? _currentModule;
  List<Module> _allModules = [];

  @override
  void initState() {
    super.initState();
    // Fetch data using BLoC when widget initializes
    context.read<PlayListBloc>().add(
        FetchDataPlayList(
            courseId: widget.courseId,
            moduleId: widget.moduleId,
            lessonId: widget.lessonId
        )
    );

    // Allow screen rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Reset orientation when disposing
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (_isInitialized) {
      _videoPlayerController.removeListener(_onVideoFinished);
      _videoPlayerController.dispose();
      _chewieController?.dispose();
    }
    super.dispose();
  }


  Future<void> _initializePlayer(Lesson lesson) async {
    _videoPlayerController = VideoPlayerController.network(
      lesson.videoUrl,
    );

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      allowFullScreen: true, // Cho phép fullscreen
      allowMuting: true,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp], // Quay về portrait khi thoát fullscreen
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ], // Chỉ cho phép landscape khi vào fullscreen
      placeholder: Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.blue,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey.shade300,
        bufferedColor: Colors.blue.withOpacity(0.5),
      ),
      fullScreenByDefault: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );

    _videoPlayerController.addListener(_onVideoFinished);

    setState(() {
      _currentLesson = lesson;
      _isInitialized = true;
    });
  }


  void _onModuleSelected(int moduleId) {
      context.read<PlayListBloc>().add(
        SelectedModule(
          moduleId: moduleId,
          modules: _allModules,
        ),
      );

  }

  void _onLessonSelected(Lesson lesson) {
    if (_currentModule != null) {
      context.read<PlayListBloc>().add(
        SelectedLesson(
          lessonId: lesson.lessonId,
          currentModule: _currentModule!,
        ),
      );
    }
  }
  bool _hasVideoFinished = false; // Thêm biến để track trạng thái

  void _onVideoFinished() {
    if (!_hasVideoFinished && // Kiểm tra xem video đã kết thúc chưa
        _videoPlayerController.value.position >= _videoPlayerController.value.duration &&
        _videoPlayerController.value.duration.inSeconds > 0) {

      _hasVideoFinished = true; // Đánh dấu video đã kết thúc

      if (mounted && _currentModule != null && _currentLesson != null) {
        context.read<PlayListBloc>().add(
          VideoFinished(
            courseId: widget.courseId,
            currentModule: _currentModule!,
            currentLesson: _currentLesson!,
            allModules: _allModules,
          ),
        );
      }
    }
  }


  void _changeVideo(Lesson lesson) {
    if (_isInitialized) {
      _videoPlayerController.removeListener(_onVideoFinished);
      _videoPlayerController.dispose();
      _chewieController?.dispose();
    }

    setState(() {
      _isInitialized = false;
      _hasVideoFinished = false; // Reset trạng thái khi đổi video
    });

    _initializePlayer(lesson);
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayListBloc, PlayListState>(
      listener: (context, state) {
        if(state is PlayListVideoFinished){
          context.read<MyCourseDetailBloc>().add(UpdateDataModule());
          context.read<MyCourseBloc>().add(FetchDataMyCourse());
        }
        if (state is PlayListLoaded) {
          setState(() {
            _currentModule = state.module;
            _allModules = state.modules;
            if (state.module != null) {
              _lessons = state.module!.lessons;
            }
            if (state.lesson != null) {
              if (!_isInitialized || _currentLesson?.lessonId != state.lesson!.lessonId) {
                _changeVideo(state.lesson!);
              }
            }
          });
        }
      },
      builder: (context, state) {
        if (state is PlayListLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is PlayListLoaded) {
          return _buildContent();
        }
        return const Scaffold(
          body: Center(
            child: Text('No content available'),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentModule?.moduleName ?? 'Video Course'),
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            // Kiểm tra xem đang ở chế độ ngang hay dọc
            bool isLandscape = orientation == Orientation.landscape;

            // Nếu ở chế độ ngang (landscape/fullscreen), chỉ hiển thị video player
            if (isLandscape) {
              return Container(
                color: Colors.black,
                child: _isInitialized
                    ? Chewie(controller: _chewieController!)
                    : const Center(child: CircularProgressIndicator()),
              );
            }

            // Ở chế độ dọc (portrait), hiển thị đầy đủ giao diện
            return Column(
              children: [
                // Video player section
                Container(
                  height: 220,
                  color: Colors.black,
                  child: _isInitialized
                      ? Chewie(controller: _chewieController!)
                      : const Center(child: CircularProgressIndicator()),
                ),

                // Phần còn lại của giao diện
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Video information section
                        if (_currentLesson != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Lesson ${_currentLesson!.orderIndex} : ${_currentLesson!.lessonName}',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _currentLesson!.content,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Divider
                        Divider(color: Colors.grey[300], height: 1),

                        // Module selection
                        if (_allModules.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: DropdownButton<int>(
                              isExpanded: true,
                              value: _currentModule?.moduleId,
                              hint: const Text('Select Module'),
                              onChanged: (moduleId) {
                                if (moduleId != null && _currentModule?.moduleId != moduleId) {
                                  _onModuleSelected(moduleId);
                                }
                              },
                              items: _allModules.map((module) {
                                return DropdownMenuItem<int>(
                                  value: module.moduleId,
                                  child: Text('  Module ${module.orderIndex}: ${module.moduleName}',style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18
                                  ),),
                                );
                              }).toList(),
                            ),
                          ),

                        // Video list section
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _lessons.length,
                          itemBuilder: (context, index) {
                            final lesson = _lessons[index];
                            final isCurrentVideo = _currentLesson?.lessonId == lesson.lessonId;
                            return Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: isCurrentVideo ? Colors.blue : Colors.transparent,
                                    width: 4,
                                  ),
                                ),
                                color: isCurrentVideo ? Colors.blue.withOpacity(0.05) : null,
                              ),
                              child: ListTile(
                                // Phần ListTile giữ nguyên
                                leading: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child:Image.network(
                                          'https://res.cloudinary.com/depram2im/image/upload/v1743389798/ai_clsgh6.jpg',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fill,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 80,
                                              height: 50,
                                              color: Colors.grey[300],
                                              child: Icon(Icons.video_library, color: Colors.grey[600]),
                                            );
                                          },
                                        )
                                    ),
                                    Container(
                                      width: 80,
                                      height: 45,
                                      color: Colors.black.withOpacity(0.2),
                                      child: Icon(
                                        isCurrentVideo ? Icons.pause : Icons.play_arrow,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  'Lesson ${lesson.orderIndex}: ${lesson.lessonName}',
                                  style: TextStyle(
                                      fontWeight:FontWeight.bold,
                                      color: isCurrentVideo ?Colors.blue :Colors.black
                                  ),
                                ),
                                subtitle: Text(
                                  lesson.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${(lesson.durationMinutes! / 60).floor()}:${(lesson.durationMinutes! % 60).toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  if (!isCurrentVideo) {
                                    _onLessonSelected(lesson);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}