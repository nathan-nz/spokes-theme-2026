import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { service } from "@ember/service";
import { block } from "discourse/blocks";
import CategoryLogo from "discourse/components/category-logo";
import Category from "discourse/models/category";
import { and } from "discourse/truth-helpers";
import { i18n } from "discourse-i18n";

@block("theme:skills:category-banner", {
  description:
    "Dynamic banner for category pages showing name, logo, and description",
  args: {
    showDescription: { type: "boolean", default: true },
    showLogo: { type: "boolean", default: true },
  },
})
export default class BlockCategoryBanner extends Component {
  @service router;

  @tracked category = null;

  get categorySlugPathWithID() {
    return this.router?.currentRoute?.params?.category_slug_path_with_id;
  }

  @action
  getCategory() {
    const slug = this.categorySlugPathWithID;
    if (!slug) {
      return;
    }
    const idMatch = slug.match(/(\d+)$/);
    if (idMatch) {
      this.category = Category.findById(parseInt(idMatch[1], 10));
    }
  }

  <template>
    <div
      class="block-category-banner__layout"
      {{didInsert this.getCategory}}
    >
      {{#if this.category}}
        {{#if (and @showLogo this.category.uploaded_logo)}}
          <div class="block-category-banner__logo">
            <CategoryLogo @category={{this.category}} />
          </div>
        {{/if}}
        <div class="block-category-banner__content">
          <h1 class="block-category-banner__name">
            {{this.category.name}}
          </h1>
          {{#if @showDescription}}
            <p class="block-category-banner__description">
              {{if
                this.category.description_text
                this.category.description_text
                (i18n (themePrefix "category_banner.fallback_description"))
              }}
            </p>
          {{/if}}
        </div>
      {{/if}}
    </div>
  </template>
}
