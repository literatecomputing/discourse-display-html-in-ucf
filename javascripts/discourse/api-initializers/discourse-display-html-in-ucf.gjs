import { apiInitializer } from "discourse/lib/api";
import AllHtmlSafeUserFields from "../components/all-html-safe-user-fields";

export default apiInitializer((api) => {
  const site = api.container.lookup("service:site");
  api.renderInOutlet(
    "user-card-before-badges",
    <template>
      <AllHtmlSafeUserFields @site={{site}} @user={{@user}} />
    </template>
  );

  api.renderInOutlet(
    "user-profile-public-fields",
    <template>
      <AllHtmlSafeUserFields @site={{site}} @user={{@model}} />
    </template>
  );
});
