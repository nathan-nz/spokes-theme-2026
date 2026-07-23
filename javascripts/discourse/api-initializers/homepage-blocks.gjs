import BlockGroup from "discourse/blocks/builtin/block-group";
import { apiInitializer } from "discourse/lib/api";
import BlockCta from "../blocks/block-cta";
import BlockFeaturedList from "../blocks/block-featured-list";
import BlockFeaturedTopics from "../blocks/block-featured-topics";
import BlockSubmissionsList from "../blocks/block-submissions-list";
import BlockUpcomingEvents from "../blocks/block-upcoming-events";

export default apiInitializer((api) => {

  api.registerValueTransformer("welcome-banner-display-for-route", ({ value }) => {
    const router = api.container.lookup("service:router");
    return router.currentRouteName === "discovery.custom" || value;
  });

  api.renderBlocks("homepage-blocks", [
    {
      block: BlockFeaturedTopics,
      id: "featured-topics",
      args: {
        title: "homepage.featured_topics.title",
        linkText: "homepage.featured_topics.link_text",
        linkUrl: `/tag/${settings.featured_topics_tag}`,
        tag: settings.featured_topics_tag,
        count: settings.featured_topics_count,
      },
      conditions: [
        { type: "setting", name: "tagging_enabled", enabled: true },
        {
          type: "setting",
          source: settings,
          name: "featured_topics_tag",
          enabled: true,
        },
      ],
    },
    {
      block: BlockFeaturedList,
      id: "featured-list",
      args: {
        title: "homepage.featured_list.title",
        linkText: "homepage.featured_list.link_text",
        linkUrl: "/latest",
        count: settings.featured_list_count,
        filter: settings.featured_list_filter,
      },
    },
    {
      block: BlockGroup,
      id: "homepage-right",
      children: [
        {
          block: BlockUpcomingEvents,
          id: "homepage-events",
          args: {
            title: "homepage.events.title",
            count: settings.events_count,
            buttonLabel: "homepage.events.button_label",
            linkLabel: "homepage.events.link_label",
            linkUrl: "/c/events",
          },
          conditions: [
            { type: "setting", name: "calendar_enabled", enabled: true },
          ],
        },
        {
          block: BlockSubmissionsList,
          id: "sidebar-submissions-list",
          args: {
            count: 6,
            tag: "submissions",
          },
        },
      ],
    },
  ]);
});
