import Component from "@glimmer/component";
import { block } from "discourse/blocks";
import AsyncContent from "discourse/components/async-content";
import { ajax } from "discourse/lib/ajax";
import { bind } from "discourse/lib/decorators";
import { i18n } from "discourse-i18n";

@block("theme:skills:sidebar-submissions", {
  description: "Compact list of topics tagged 'submissions'",
  args: {
    title: { type: "string" },
    count: { type: "number", default: 6 },
    tag: { type: "string", default: "submissions" },
  },
})
export default class BlockSubmissions extends Component {
  @bind
  async fetchTopics() {
    const count = this.args.count || 6;
    const tag = this.args.tag || "submissions";
    const results = await ajax(`/tag/${tag}.json`);

    if (!results.topic_list?.topics?.length) {
      return null;
    }

    return results.topic_list.topics.slice(0, count);
  }

  <template>
    <AsyncContent @asyncData={{this.fetchTopics}}>
      <:loading>
        <div class="block-submissions__loading">
          <div class="spinner" />
        </div>
      </:loading>

      <:empty>
        <div class="block-submissions__empty">
          {{i18n "sidebar.nothing"}}
        </div>
      </:empty>

      <:content as |topics|>
        <div class="block-submissions__layout">
          {{#if @title}}
            <h4 class="block-submissions__title">{{i18n (themePrefix @title)}}</h4>
          {{/if}}
          <div class="block-submissions__list">
            {{#each topics as |topic|}}
              <a
                href={{topic.url}}
                class="block-submissions__item"
              >
                <span class="block-submissions__item-title">
                  {{topic.title}}
                </span>
                <span class="block-submissions__item-meta">
                  {{topic.replyCount}}
                  {{i18n "replies"}}
                  ·
                  {{topic.views}}
                  {{i18n "views"}}
                </span>
              </a>
            {{/each}}
          </div>
          <a href="/tag/submissions" class="block-submissions__see-all">
            See all submissions
          </a>
        </div>
      </:content>

    </AsyncContent>
  </template>
}
