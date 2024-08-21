import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Text "mo:base/Text";

import Types "Types";

actor {

   public func greet(mood: Text) : async Text {
    switch (mood) {
      case "😊" {
        return await send_http_post_request("User is Happy, make some short boost up sentence and just reply with the sentence");
      };
      case "😢" {
        return await send_http_post_request("User is Sad, make some short boost up sentence and just reply with the sentence");
      };
      case "😠" {
        return await send_http_post_request("User is Angry, make some short boost up sentence and just reply with the sentence");
      };
      case _ {
        return "Hey there! How can I help you today?";
      };
    }
  };

  public query func transform(raw : Types.TransformArgs) : async Types.CanisterHttpResponsePayload {
      let transformed : Types.CanisterHttpResponsePayload = {
          status = raw.response.status;
          body = raw.response.body;
          headers = [
              {
                  name = "Content-Security-Policy";
                  value = "default-src 'self'";
              },
              { name = "Referrer-Policy"; value = "strict-origin" },
              { name = "Permissions-Policy"; value = "geolocation=(self)" },
              {
                  name = "Strict-Transport-Security";
                  value = "max-age=63072000";
              },
              { name = "X-Frame-Options"; value = "DENY" },
              { name = "X-Content-Type-Options"; value = "nosniff" },
          ];
      };
      transformed;
  };

//PUBLIC METHOD
//This method sends a POST request to a URL with a free API you can test.
  public func send_http_post_request(message : Text) : async Text {
      // 1. DECLARE MANAGEMENT CANISTER
      let ic : Types.IC = actor ("aaaaa-aa");

      // 2. SETUP ARGUMENTS FOR HTTP POST request

      // 2.1 Setup the URL
      let host : Text = "api.openai.com";
      let url = "https://api.openai.com/v1/chat/completions";

      // 2.2 Prepare headers for the HTTP request
      let idempotency_key: Text = generateUUID();
      let request_headers = [
          { name = "Host"; value = host # ":443" },
          { name = "User-Agent"; value = "http_post_sample" },
          { name= "Content-Type"; value = "application/json" },
          { name= "Idempotency-Key"; value = idempotency_key },
          { name = "Authorization"; value = "Bearer " # "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" },
      ];

      // Prepare the JSON request body
      let model: Text = "gpt-4o-mini";
      let json_body: Text = "{\"model\": \"" # model # "\", \"messages\": [{\"role\": \"user\", \"content\": \"" # message # "\"}], \"temperature\": 0.5}";

      // Convert the JSON string to Blob
      let request_body_as_Blob: Blob = Text.encodeUtf8(json_body);
      let request_body_as_nat8: [Nat8] = Blob.toArray(request_body_as_Blob);

      // 2.2.1 Transform context
      let transform_context : Types.TransformContext = {
          function = transform;
          context = Blob.fromArray([]);
      };

      // 2.3 The HTTP request
      let http_request : Types.HttpRequestArgs = {
          url = url;
          max_response_bytes = null;
          headers = request_headers;
          body = ?request_body_as_nat8;
          method = #post;
          transform = ?transform_context;
      };

      // 3. ADD CYCLES TO PAY FOR HTTP REQUEST
      Cycles.add(21_850_258_000);

      // 4. MAKE HTTP REQUEST AND WAIT FOR RESPONSE
      let http_response : Types.HttpResponsePayload = await ic.http_request(http_request);

      // 5. DECODE THE RESPONSE
      let response_body: Blob = Blob.fromArray(http_response.body);
      let decoded_text: Text = switch (Text.decodeUtf8(response_body)) {
          case (null) { "No value returned" };
          case (?y) { y };
      };

      // 6. RETURN RESPONSE OF THE BODY
      let result: Text = decoded_text # ". See more info of the request sent at: " # url # "/inspect";
      result
  };

  // PRIVATE HELPER FUNCTION
  func generateUUID() : Text {
      "UUID-123456789";
  }


};
