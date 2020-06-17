local addonName, _ = ...;

-- Loot Frame

LootPromptMixin = {};

function LootPromptMixin:OnLoad()
end

function LootPromptMixin:OnShow()
end

function LootPromptMixin:OnHide()
end

-- Need Button

NeedButtonMixin = {};

function NeedButtonMixin:OnClick(button, down)
	LootPrompt:Hide();
end

-- Greed Button

GreedButtonMixin = {};

function GreedButtonMixin:OnClick(button, down)
	LootPrompt:Hide();
end
