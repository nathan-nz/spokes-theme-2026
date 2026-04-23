import { apiInitializer } from "discourse/lib/api";
import BlockHomeLink from "../blocks/block-home-link";

export default apiInitializer((api) => {
  api.renderBlocks("sidebar-blocks", [
    {
      block: BlockHomeLink,
      id: "home-link",
      args: {
        label: "sidebar.home_link",
      },
      conditions: {
        not: { type: "route", pages: ["ADMIN_PAGES"] },
      },
    },
  ]);
});
