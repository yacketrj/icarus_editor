import 'dart:convert';
import 'dart:io';

import 'package:icarus_editor/services/folders.dart';
import 'package:icarus_editor/services/icarus_character.dart';
import 'package:icarus_editor/services/icarus_profile.dart';

const String _charactersKey = 'Characters.json';

class IcarusSave {
  final Directory directory;
  late File _charactersFile;
  late File _profileFile;
  final List<IcarusCharacter> characters = List.empty(growable: true);
  late IcarusProfile profile;

  IcarusSave({required this.directory}) {
    _charactersFile = getFileInIcarusSaveFolder(directory, 'Characters.json');
    _profileFile = getFileInIcarusSaveFolder(directory, 'Profile.json');
  }

  Future initialize() async {
    if (await _charactersFile.exists() == false) {
      throw FileSystemException(
          'Could not load characters', _charactersFile.path);
    }
    if (await _profileFile.exists() == false) {
      throw FileSystemException('Could not load profile', _profileFile.path);
    }

    var charactersContent = await _charactersFile.readAsString();
    var rawCharacters = json.decode(charactersContent)[_charactersKey];
    for (var rawCharacter in rawCharacters) {
      var decoded = json.decode(rawCharacter);

      characters.add(IcarusCharacter(character: decoded, save: this));
    }

    var profileContent = await _profileFile.readAsString();
    var rawProfile = json.decode(profileContent);
    profile = IcarusProfile(profile: rawProfile, save: this);
  }
}
