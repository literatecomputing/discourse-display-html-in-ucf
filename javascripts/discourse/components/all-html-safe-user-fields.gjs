import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";

export default class AllHtmlSafeUserFields extends Component {
  get htmlSafeFieldIds() {
    const settingValue = settings?.custom_user_field_ids || "";

    return String(settingValue).split("|").filter(Boolean);
  }

  get fields() {
    const site = this.args.site;
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
        };
      })
      .filter(Boolean);
  }

  <template>
    {{#each this.fields as |field|}}
      <div
        class="html-safe-public-user-field html-safe-ucf"
        data-field-id={{field.id}}
      >
        <span class="user-field-name">{{field.name}}: </span>
        <span class="user-field-value">{{field.value}}</span>
      </div>
    {{/each}}
  </template>
}
