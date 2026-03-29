# Resizable Multi-Pane Layout

## Summary

This skill documents a reusable pattern for building 3+ pane UIs where users need to control panel widths. Used successfully in the Section Builder (Elements palette, canvas, details pane). Includes component code, test templates, and implementation guide.

## When to Use

Building UI with **3+ side panels** that display different data dimensions (e.g., elements palette, canvas, details pane). Users need to adjust panel widths based on content they're focusing on.

## The Pattern

### Component Structure

```typescript
// ResizableSidePanel.tsx — single reusable component
// Props: side ('left'|'right'), expanded (boolean), collapsedWidth, onWidthChange callback

// Parent page uses it for left and right panels:
<ResizableSidePanel
  side="left"
  expanded={leftPanelState === 'expanded'}
  onToggle={toggleLeftPanel}
  collapsedWidth="w-8"
  collapsedLabel="ELEMENTS"
  storedWidth={leftPanelWidth}
  onWidthChange={(newWidth) => {
    setLeftPanelWidth(newWidth);
    localStorage.setItem('builderLeftPanelWidth', newWidth.toString());
  }}
>
  {children}
</ResizableSidePanel>
```

### Key Implementation Details

**1. Resize Handle (invisible until hover)**
```typescript
{expanded && (
  <div
    onMouseDown={handleMouseDown}
    className={`
      absolute top-0 bottom-0 w-1.5 transition-colors
      ${isResizing ? 'bg-[var(--primary)]' : 'bg-[var(--background-dark)] hover:bg-[var(--primary)]'}
      cursor-col-resize
    `}
    style={{
      [side === 'left' ? 'right' : 'left']: '-3px',
      zIndex: 5,
    }}
    title={`Drag to resize ${side} panel`}
  />
)}
```
- Positioned at `-3px` outside the panel for easy targeting
- Only renders when expanded (no resize during collapsed)
- Changes color on hover → visual feedback
- `cursor-col-resize` tells the user what happens on drag

**2. Drag Logic (document-level listeners)**
```typescript
const handleMouseDown = (e: React.MouseEvent) => {
  if (!expanded) return; // Don't resize when collapsed
  e.preventDefault();
  setIsResizing(true);
  startXRef.current = e.clientX;
  startWidthRef.current = width;
};

useEffect(() => {
  if (!isResizing) return;

  const handleMouseMove = (e: MouseEvent) => {
    const delta = side === 'left' 
      ? e.clientX - startXRef.current 
      : startXRef.current - e.clientX;

    const newWidth = Math.max(200, Math.min(600, startWidthRef.current + delta));
    setWidth(newWidth);
  };

  const handleMouseUp = () => setIsResizing(false);

  document.addEventListener('mousemove', handleMouseMove);
  document.addEventListener('mouseup', handleMouseUp);

  return () => {
    document.removeEventListener('mousemove', handleMouseMove);
    document.removeEventListener('mouseup', handleMouseUp);
  };
}, [isResizing, side]);
```
- **Use document listeners, not container**: If you only listen to the container, dragging fast past its edge loses tracking
- **Direction math matters**: left panel drag right = positive delta; right panel drag left = positive delta (opposite directions)
- **Boundary constraints**: `Math.max(200, Math.min(600, ...))` prevents pathological widths

**3. Persistence (localStorage)**
```typescript
const [width, setWidth] = useState<number>(() => {
  if (typeof window !== 'undefined') {
    const saved = localStorage.getItem('builderLeftPanelWidth');
    return saved ? parseInt(saved, 10) : 224; // default w-56
  }
  return 224;
});

useEffect(() => {
  if (onWidthChange) {
    onWidthChange(width);
    localStorage.setItem('builderLeftPanelWidth', width.toString());
  }
}, [width, onWidthChange]);
```
- Initialize from localStorage on mount, fall back to sensible default
- Save on every width change (not debounced — lag is unacceptable for resize)
- Check `window` exists (SSR safety)

**4. Display Logic (inline width or class)**
```typescript
const displayWidth = expanded ? `${width}px` : collapsedWidth;
// Use this in the style prop
<div style={{ width: displayWidth, ...otherStyles }}>
```
- When expanded: use exact pixel width from resize
- When collapsed: use Tailwind class (w-8, w-0, etc.) for minimal footprint
- Transition smoothly with `transition-all duration-300`

### Parent State Management

```typescript
const [leftPanelWidth, setLeftPanelWidth] = useState<number>(() => {
  if (typeof window !== 'undefined') {
    const saved = localStorage.getItem('builderLeftPanelWidth');
    return saved ? parseInt(saved, 10) : 224;
  }
  return 224;
});

// In JSX:
<ResizableSidePanel
  side="left"
  expanded={leftPanelState === 'expanded'}
  onToggle={toggleLeftPanel}
  collapsedWidth="w-8"
  collapsedLabel="ELEMENTS"
  storedWidth={leftPanelWidth}
  onWidthChange={(newWidth) => {
    setLeftPanelWidth(newWidth);
    localStorage.setItem('builderLeftPanelWidth', newWidth.toString());
  }}
>
  <ElementsPalette />
</ResizableSidePanel>
```

## Tests to Add

**File**: `src/components/common/__tests__/ResizableSidePanel.test.tsx`

```typescript
describe('ResizableSidePanel', () => {
  it('should render resize handle only when expanded', () => {
    // collapsed → no handle
    // expanded → handle present with cursor-col-resize
  });

  it('should resize left panel rightward on drag', () => {
    // drag from x=100 to x=150 → width increases by 50
  });

  it('should resize right panel leftward on drag', () => {
    // drag from x=500 to x=450 → width increases by 50
  });

  it('should respect min (200px) and max (600px) constraints', () => {
    // try to drag below 200 → stays at 200
    // try to drag above 600 → stays at 600
  });

  it('should persist width to localStorage on drag end', () => {
    // localStorage.getItem('builderLeftPanelWidth') === '280'
  });

  it('should load width from localStorage on mount', () => {
    // localStorage has 350 → component renders at 350px
  });

  it('should not resize when collapsed', () => {
    // expanded=false → handleMouseDown returns early
  });

  it('should call onWidthChange callback during drag', () => {
    // const mockCallback = jest.fn();
    // drag → callback called with new width
  });
});
```

## Common Pitfalls

❌ **Only listen to container**: Dragging past the edge loses tracking  
✅ **Use document-level mouseMove/mouseUp**

❌ **Store width as Tailwind class**: Can't persist numeric values  
✅ **Store as pixels, use inline style**

❌ **Resize when collapsed**: Invisible but still responsive = confusing  
✅ **Guard with `if (!expanded) return`**

❌ **Debounce resize callback**: Feels laggy  
✅ **Update synchronously on every move**

❌ **Forget SSR check**: localStorage doesn't exist server-side  
✅ **Check `typeof window !== 'undefined'`**

## Example: Three-Pane Layout

```
┌─────────────────────────────────────────┐
│ Header                                  │
├──────────┬─────────────────────┬────────┤
│ Sections │ Canvas (flex-1)     │Details │
│ Panel    │                     │ Panel  │
│(w-56)    │                     │(w-72)  │
│          │ ← use remaining     │        │
│          │   space via flex-1  │        │
└──────────┴─────────────────────┴────────┘
```

- **Sections panel**: Fixed width (handled by `CollapsibleSectionsList`, not resizable)
- **Canvas**: `flex-1` — takes remaining space
- **Elements panel** (left): Resizable, 224px default
- **Details panel** (right): Resizable, 288px default

When user resizes Elements panel to 350px, canvas shrinks to `flex-1` remaining width. No re-calculation needed — flexbox handles it.

## Reusability

This pattern works for any 3+ pane layout:
- Section builder (elements, canvas, details)
- Code editor (file explorer, editor, problems panel)
- Design tool (layers, canvas, inspector)
- Query builder (sources, builder, results)

Just change the `children` and localStorage keys.
