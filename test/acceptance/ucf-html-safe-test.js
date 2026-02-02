import { visit } from "@ember/test-helpers";
import { test } from "qunit";
import { acceptance } from "discourse/tests/helpers/qunit-helpers";

acceptance("User Custom Fields - HTML Safe", function(needs) {
  needs.settings({ custom_user_field_ids: "1" });
  
  needs.site({
    user_fields: [
      { id: 1, name: "Field 1", show_on_profile: true },
      { id: 2, name: "Field 2", show_on_profile: true }
    ]
  });

  needs.pretender((server, helper) => {
    const userData = {
      id: 1,
      username: "testuser",
      name: "Test User",
      user_fields: {
        "1": "<b>bold</b>",
        "2": "<i>italic</i>"
      }
    };

    server.get("/u/testuser.json", () => {
      return helper.response({ user: userData });
    });

    server.get("/u/testuser/summary.json", () => {
      return helper.response({
        user_summary: {
          topics: [],
          replies: [],
          links: [],
          most_liked_by_users: [],
          most_liked_users: [],
          most_replied_to_users: [],
          badges: [],
          top_categories: [],
          top_pms: [],
          bookmarks: [],
          upcoming_events: [],
          featured_topics: []
        },
        user: userData
      });
    });
  });

  test("User fields rendering logic", async function(assert) {
    await visit("/u/testuser");

    assert.dom(".html-safe-ucf[data-field-id='1'] .user-field-value b").exists("Field 1 renders HTML (bold tag found)");
    assert.dom(".html-safe-ucf[data-field-id='2'] .user-field-value i").doesNotExist("Field 2 does not render HTML (italic tag not found)");
    assert.dom(".html-safe-ucf[data-field-id='2'] .user-field-value").hasText("<i>italic</i>", "Field 2 renders as plain text");
  });
});
