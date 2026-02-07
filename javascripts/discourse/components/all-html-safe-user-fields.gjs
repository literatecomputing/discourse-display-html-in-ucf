import Component from "@glimmer/component";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
// Theme settings are accessed via the global 'settings' object in Discourse themes

export default class AllHtmlSafeUserFields extends Component {
  @service site;

  get htmlSafeFieldIds() {
    // Access theme setting from global settings object
    const settingValue = settings?.custom_user_field_ids || "";

    return String(settingValue).split("|").filter(Boolean);
  }

  get fields() {
    const site = this.site;
    const user = this.args.user;
    const htmlSafeFieldIds = this.htmlSafeFieldIds;
    if (!site?.user_fields || !user?.user_fields) {
      return [];
    }

    return site.user_fields
      .map((field) => {
        const value = user.user_fields[String(field.id)];
        if (!value) {
          return null;
        }
        const isHtmlSafe = htmlSafeFieldIds.includes(String(field.id));
        return {
          name: field.name,
          value: isHtmlSafe ? htmlSafe(value) : value,
          id: field.id,
          shouldRender:
            this.args.page === "user-profile"
              ? field.show_on_profile
              : field.show_on_user_card,
        };
      })
      .filter(Boolean);
  }

  <template>
    {{#each this.fields as |field|}}
      {{#if field.shouldRender}}
        <div
          class="html-safe-public-user-field html-safe-ucf public-user-field__{{field.name}}"
          data-field-id={{field.id}}
        >
          <span class="user-field-name">{{field.name}}: </span>
          <span class="user-field-value">{{field.value}}</span>
        </div>
      {{/if}}
    {{/each}}
  </template>
}
