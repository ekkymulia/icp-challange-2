actor {
  public query func greet(mood: Text) : async Text {
    switch (mood) {
      case "😊" {
        return "You're amazing! Keep smiling and shining!";
      };
      case "😢" {
        return "It's okay to feel down sometimes. Hang in there, things will get better!";
      };
      case "😠" {
        return "Take a deep breath. Let go of the anger and find your calm!";
      };
      case _ {
        return "Hey there! How can I help you today?";
      };
    }
  };
};
