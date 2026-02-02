import { apiInitializer } from "discourse/lib/api";
import AllHtmlSafeUserFields from "../components/all-html-safe-user-fields";

export default apiInitializer((api) => {
  api.renderInOutlet(
    "user-card-before-badges",
    <template><AllHtmlSafeUserFields @user={{@user}} /></template>
  );

  api.renderInOutlet(
    "user-profile-public-fields",
    <template><AllHtmlSafeUserFields @user={{@model}} /></template>
  );
});
