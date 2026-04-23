import { apiInitializer } from "discourse/lib/api";
import BlockCategoryTopics from "../blocks/block-category-topics";
import BlockTopTags from "../blocks/block-top-tags";

export default apiInitializer((api) => {
  api.renderBlocks("sidebar-discovery", [
    {
      block: BlockCategoryTopics,
      id: "sidebar-category-topics",
      args: {
        categoryId: settings.sidebar_category_id,
        count: 8,
      },
      conditions: [
        {
          type: "route",
          pages: ["CATEGORY_PAGES"],
          params: { categorySlug: "general" },
        },
        { type: "viewport", min: "lg" },
      ],
    },
    {
      block: BlockTopTags,
      id: "sidebar-top-tags",
      args: {
        title: "sidebar.top_tags.title",
        count: settings.sidebar_tags_count,
      },
      conditions: [
        {
          type: "route",
          pages: ["CATEGORY_PAGES"],
          params: { categorySlug: "general" },
        },
        { type: "viewport", min: "lg" },
      ],
    },
  ]);
});
