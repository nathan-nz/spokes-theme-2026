import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import { block } from "discourse/blocks";
import replaceEmoji from "discourse/helpers/replace-emoji";

@block("theme:block:submissions-list", {
  description: "Recent topics from a tag",
  args: {
    tag: { type: "string", default: "submissions" },
    count: { type: "number", default: 10 },
  },
})
export default class BlockSubmissionsList extends Component {
  @service store;

  @tracked topics = null;

  constructor() {
    super(...arguments);
    const count = this.args.count || 10;
    const tag = this.args.tag || "submissions";

    if (!tag) {
      return;
    }

    const filter = `tag/${tag}`;

    this.store.findFiltered("topicList", { filter }).then((topicList) => {
      if (topicList.topics) {
        this.topics = topicList.topics.slice(0, count);
      }
    });
  }

  willDestroy() {
    super.willDestroy(...arguments);
    this.topics = null;
  }

  <template>
    {{#if this.topics}}
      <div class="block-submissions-list__layout">
        <div class="block-submissions-list__header">
          <h3 class="block-submissions-list__title">
            Submissions
          </h3>
          <a href="/tag/submissions" class="block-submissions-list__link">
            See all
          </a>
        </div>
        <div class="block-submissions-list__list">
          {{#each this.topics as |topic|}}
            <a href={{topic.url}} class="block-submissions-list__topic">
              {{htmlSafe (replaceEmoji topic.fancy_title)}}
              <span class="block-submissions-list__post-count">
                ({{topic.posts_count}})
              </span>
            </a>
          {{/each}}
        </div>
      </div>
    {{/if}}
  </template>
}
