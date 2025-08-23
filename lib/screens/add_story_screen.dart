import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/add_story_provider.dart';

class AddStoryScreen extends StatelessWidget {
  const AddStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Story')),
      body: Consumer<AddStoryProvider>(
        builder: (context, addStoryProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    addStoryProvider.image == null
                        ? const Text('No image selected.')
                        : Image.file(addStoryProvider.image!, height: 200),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => addStoryProvider.pickImage(),
                      child: const Text('Pick Image'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    addStoryProvider.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final success = await addStoryProvider.addStory(
                                descriptionController.text,
                              );
                              if (success) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      addStoryProvider.message ??
                                          'Story added successfully!',
                                    ),
                                  ),
                                );
                                context.pop();
                              } else {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      addStoryProvider.message ??
                                          'Failed to add story.',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Add Story'),
                        ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
